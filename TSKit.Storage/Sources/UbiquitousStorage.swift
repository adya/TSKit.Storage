import Foundation

/// iCloud Storage.
@available(iOS 8.0, *)
class UbiquitousStorage : AnyStorage {
    private var storage = NSUbiquitousKeyValueStore.default
    
    func value(forKey key: String) -> Any? {
        return storage.value(forKey: key)
    }
    
    func set(_ value: Any, forKey key: String) -> Bool {
        storage.set(value, forKey: key)
        return true
    }
    
    func removeValue(forKey key: String) -> Bool {
        storage.removeObject(forKey: key)
        return true
    }
    
    func removeAll() -> Bool {
        dictionary.keys.forEach {
            storage.removeObject(forKey: $0)
        }
        storage.synchronize()
        return true
    }
    
    var count: Int {
        return dictionary.count
    }
    
    var dictionary: [String : Any] {
        return storage.dictionaryRepresentation
    }
    
    deinit {
        storage.synchronize()
    }
}
