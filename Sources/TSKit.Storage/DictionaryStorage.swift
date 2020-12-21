// - Since: 01/21/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

public class DictionaryStorage : AnyDynamicStorage {
    
    private var storage = [String : Any]()
    
    public init() {}
    
    public func value(forKey key: String) -> Any? {
        return storage[key]
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
        return storage.count
    }
    
    public var dictionary: [String : Any] {
        return storage
    }
}
