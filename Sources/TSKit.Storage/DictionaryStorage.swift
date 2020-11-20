// - Since: 01/21/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation

public class DictionaryStorage : AnyDynamicStorage, AnyTypedStorage {
    
    private var storage = [String : Any]()
    
    public func value(forKey key: String) -> Any? {
        storage[key]
    }
    
    public func set(_ value: Any, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }
    
    public func removeValue(forKey key: String) -> Bool {
        storage[key] = nil
        return true
    }
    
    public func removeAll() -> Bool {
        storage.removeAll()
        return true
    }
    
    public var count: Int {
        storage.count
    }
    
    public var dictionary: [String : Any] {
        storage
    }
}
