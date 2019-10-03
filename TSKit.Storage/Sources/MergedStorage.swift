/// - Since: 01/21/2018
/// - Authors: Arkadii Hlushchevskyi
/// - Copyright: © 2018. Arkadii Hlushchevskyi.
/// - Seealsos: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import TSKit_Core

/// Merges multiple storages into one.
public class MergedStorage : AnyReadableStorage {
    
    private let storages : [AnyReadableStorage]
    
    public init(storages: [AnyReadableStorage]) {
        self.storages = storages
    }
    
    public func value(forKey key: String) -> Any? {
        for storage in storages {
            if let value = storage[key] {
                return value
            }
        }
        return nil
    }
   
    public var count: Int {
        return storages.reduce(0) { $0 + $1.count }
    }
    
    public var dictionary: [String : Any] {
        return storages.reduce([:]) { $0 + $1.dictionary }
    }
}
