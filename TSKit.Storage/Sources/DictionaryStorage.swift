/// - Since: 01/21/2018
/// - Author: Arkadii Hlushchevskyi
/// - Copyright: © 2018. Arkadii Hlushchevskyi.
/// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

class DictionaryStorage : AnyStorage {
    
    private var storage = [String : Any]()
    
    func value(forKey key: String) -> Any? {
        return storage[key]
    }
    
    func set(_ value: Any, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }
    
    func removeValue(forKey key: String) -> Bool {
        storage[key] = nil
        return true
    }
    
    func removeAll() -> Bool {
        storage.removeAll()
        return true
    }
    
    var count: Int {
        return storage.count
    }
    
    var dictionary: [String : Any] {
        return storage
    }
}
