/// - Since: 01/21/2018
/// - Authors: Arkadii Hlushchevskyi
/// - Copyright: © 2018. Arkadii Hlushchevskyi.
/// - Seealsos: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation

@available(iOS 8.0, *)
public class PlistStorage : AnyReadableStorage {
    
    private var plist : [String : Any] = [:]
    
    public init?(plistName : String, bundle : Bundle? = nil) {
        let bundle = bundle ?? Bundle.main
        guard let url = bundle.url(forResource: plistName, withExtension: "plist") else {
            log(error: .load(plistName, .missing))
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            log(error: .load(plistName, .invalidData))
            return nil
        }
        guard let result = (try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)) as? [String : Any] else {
            log(error: .load(plistName, .invalidRoot))
            return nil
        }
        
        plist = result
    }
   
    public func value(forKey key: String) -> Any? {
        return plist[key]
    }
    
    public var count: Int {
        return plist.count
    }
    
    public var dictionary: [String : Any] {
        return plist
    }
    
    private func log(error : StorageError) {
        let msg : String
        switch error {
        case let .load(_, reason): msg = "\(error.description). Reason: \(reason.rawValue)."
        }
        print("\(type(of: self)): . \(msg).")
    }
}

private enum StorageError {

    case load(String, LoadingErrorReason)
    
    var description : String {
        switch self {
        case let .load(plist): return "Failed to load \(plist).plist"
        }
    }
}

private enum LoadingErrorReason : String {
    case missing = "No such plist file in specified bundle."
    case invalidData = "Failed to load content of plist"
    case invalidRoot = "Plist's root object is not a dictionary."
}
