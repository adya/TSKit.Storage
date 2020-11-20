// - Since: 01/21/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import TSKit_Core

/// Merges multiple storages into one.
public class MergedStorage : AnyReadableDynamicStorage {
    
    private let storages : [AnyReadableDynamicStorage]
    
    public init(storages: [AnyReadableDynamicStorage]) {
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
