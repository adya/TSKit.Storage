// - Since: 01/21/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation

/// Storage data source that reads specified property list file contained in specified `Bundle`.
@available(iOS 8.0, *)
@available(*, deprecated, message: "Superceeded by PlistStorage")
public class BundlePlistStorage: AnyReadableDynamicStorage {
    
    private let plist: [String: Any]
    
    /// Creates a `BundlePlistStorage` for given property list.
    ///
    /// If given file couldn't be found within `Bundle` or couldn't be loaded the `StorageError` will be thrown.
    /// - Parameter plistName: Name of the property list file in the `bundle`.
    /// - Parameter bundle: Bundle that contains desired property list. Defaults to `.main`.
    public init(plistName: String, bundle: Bundle? = nil) throws {
        let bundle = bundle ?? Bundle.main
        guard let url = bundle.url(forResource: plistName, withExtension: "plist") else {
            throw StorageError.load(plistName, .missing)
        }
        guard let data = try? Data(contentsOf: url) else {
            throw StorageError.load(plistName, .invalidData)
        }
        guard let result = (try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)) as? [String : Any] else {
            throw StorageError.load(plistName, .invalidRoot)
        }
        
        plist = result
    }

    public func value(forKey key: String) -> Any? { plist[key] }
    
    public var count: Int { plist.count }
    
    public var dictionary: [String : Any] { plist }
}

public extension BundlePlistStorage {
    
    enum StorageError: Error, CustomStringConvertible {
        
        case load(String, LoadingErrorReason)
        
        public var description : String {
            switch self {
            case .load(let plist, let reason): return "Failed to load \(plist).plist file due to error: \(reason)."
            }
        }
        
        public enum LoadingErrorReason : String {
            case missing = "No such plist file in specified bundle"
            case invalidData = "Failed to load content of plist"
            case invalidRoot = "Plist's root object is not a dictionary"
        }
    }
}
