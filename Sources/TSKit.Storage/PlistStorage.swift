// - Since: 02/18/2022
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020-2023. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation

import TSKit_Core

/// A storage that is backed by a property list file.
///
/// The storage provides standartized API to work with the values stored in a given property list file.
/// It caches the content of the backing storage file. Changes to this storage are immediately applied in the cache and are scheduled asynchrounously to be written to the backing storage file.
/// When creating an instance of `PlistStorage` it will initialize itself with contents of the file if it exists,
/// or will create an empty property list file.
///
/// - Important: The storage does not support concurernt access to the property list file,
///              so avoid using multiple instances of `PlistStorage` with the same backing storage file.
public class PlistStorage: AnyDynamicStorage {

    @Synchronized
    private var plist: [String: Any] = [:]
    
    private let plistPath: URL
    
    private let isWritable: Bool
    
    private var plistFormat: PropertyListSerialization.PropertyListFormat = .xml
    
    private let throttler: Throttler = .init(throttlingInterval: 1)
    
    public convenience init(plistPath: URL) throws {
        guard plistPath.isFileURL else {
            throw StorageError.invalidPath(path: plistPath.absoluteString)
        }
        
        guard plistPath.pathExtension == "plist" else {
            throw StorageError.invalidFile(fileName: plistPath.lastPathComponent)
        }
        
        try self.init(url: plistPath, writable: true)
    }
    
    public convenience init(named name: String, in bundle: Bundle = .main) throws {
        guard let url = bundle.url(forResource: name, withExtension: "plist") else {
            throw StorageError.invalidBundle(name: name, bundle: bundle)
        }
        try self.init(url: url, writable: false)
    }
    
    private init(url: URL, writable: Bool) throws {
        self.isWritable = writable
        self.plistPath = url
        
        try prepareStorage()
        try readStorage()
    }
    
    deinit {
        try? writeStorage()
    }
    
    public var count: Int { plist.count }
    
    public var dictionary: [String : Any] { plist }
    
    public func value(forKey key: String) -> Any? {
        plist[key]
    }
    
    @discardableResult
    public func set(_ value: Any, forKey key: String) -> Bool {
        plist[key] = value
        scheduleWritingStorage()
        return true
    }
    
    @discardableResult
    public func removeValue(forKey key: String) -> Bool {
        plist[key] = nil
        scheduleWritingStorage()
        return true
    }
    
    @discardableResult
    public func removeAll() -> Bool {
        plist.removeAll()
        scheduleWritingStorage()
        return true
    }
}

// MARK: - Syncing with backing storage
private extension PlistStorage {
    
    /// Initializes a backing-storage file.
    func prepareStorage() throws {
        guard !FileManager.default.fileExists(atPath: plistPath.path) else { return }
        try writeStorage()
    }
    
    func readStorage() throws {
        let data = try Data(contentsOf: plistPath)
        var format: PropertyListSerialization.PropertyListFormat = .xml
        guard let dictioanry = try PropertyListSerialization.propertyList(from: data, options: [], format: &format) as? [String : Any] else {
            throw StorageError.unexpectedRoot(fileName: plistPath.lastPathComponent)
        }
        self.plistFormat = format
        self.plist = dictioanry
    }
    
    func writeStorage() throws {
        if !PropertyListSerialization.propertyList(plist, isValidFor: plistFormat) {
            // plist is no longer suited for selected format, trying to find a new appropriate format.
            plistFormat = try preferredFormat(for: plist)
        }
        
        let data = try PropertyListSerialization.data(fromPropertyList: plist,
                                                      format: plistFormat,
                                                      options: .zero)
        try data.write(to: plistPath, options: .atomic)
    }
    
    func scheduleWritingStorage() {
        throttler.throttle { [weak self] in
            do {
                try self?.writeStorage()
            } catch {
                print("PlistStorage writing failure. \(error)")
            }
        }
    }
    
    // TODO: Add DisptachSource to detect writes to the backing storage file, to support synchronization between them.
//    private func scheduleReadingStorage() {
//    }
    
    /// Finds the most appropriate format for the current `plist` values.
    func preferredFormat(for plist: Any) throws -> PropertyListSerialization.PropertyListFormat {
        let availableFormats: [PropertyListSerialization.PropertyListFormat] = [.xml, .binary, .openStep]
        
        guard let format = availableFormats.first(where: { PropertyListSerialization.propertyList(plist, isValidFor: $0)}) else {
            throw StorageError.unsupportedFormat
        }
        
        return format
    }
}

public extension PlistStorage {
    
    enum StorageError: LocalizedError {
        
        case invalidBundle(name: String, bundle: Bundle)
        
        case invalidFile(fileName: String)
        
        case unsupportedFormat
        
        case unexpectedRoot(fileName: String)
        
        case invalidPath(path: String)
        
        public var errorDescription: String? {
            switch self {
            case .invalidBundle(let name, _):
                return "\(name).plist is invalid"
            case .invalidFile(let file):
                return "\(file) is not valid for \(PlistStorage.self)."
            case .invalidPath(let path):
                return "\(path) is not a valid file URL."
            case .unsupportedFormat:
                return "Current storage values cannot be saved to property list file."
            case .unexpectedRoot(let file):
                return "\(file) has unsupported root node."
            }
        }
        
        public var failureReason: String? {
            switch self {
            case .invalidBundle(_, let bundle):
                return "Property list file with provided name couldn't be found in specified bundle \(bundle)"
            case .invalidFile:
                return "File provided to the storage is not a property list file."
            case .invalidPath:
                return "Provided URL is not a valid file URL."
            case .unsupportedFormat:
                return "One or more values contained in the storage cannot be represented in any supported propery list format."
            case .unexpectedRoot:
                return "\(PlistStorage.self) supports only Dictionary structure as a root node of the file."
            }
        }
        
        public var recoverySuggestion: String? {
            switch self {
            case .invalidBundle(let name, let bundle):
                return "Make sure that '\(name).plist' is available in \(bundle)."
            case .invalidFile:
                return "Make sure to provide a valid URL to a property list file."
            case .invalidPath:
                return "Make sure to provide a valid file URL. Such URLs has \"file://\" schema."
            case .unsupportedFormat:
                return "Review contents of the storage and make sure it contains all values of any of the following types: String, Integer types, Floating-point types, Bool, Data, Date, Dictionary or Array."
            case .unexpectedRoot:
                return "Make sure that file has a Dictionary as the root node. If the file is accessed by other APIs, ensure that they do not replace the root node with Array."
            }
        }
    }
}
