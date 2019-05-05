/// - Since: 01/21/2018
/// - Author: Arkadii Hlushchevskyi
/// - Copyright: © 2018. Arkadii Hlushchevskyi.
/// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation

/// `NSUserDefaults` storage data source.
@available(iOS 8, *)
class UserDefaultsStorage : AnyStorage {
    private var storage = UserDefaults.standard
    
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
        return storage.dictionaryRepresentation()
    }
    deinit {
        storage.synchronize()
    }
}
