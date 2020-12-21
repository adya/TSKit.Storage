// - Since: 01/21/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation

/// iCloud Storage.
@available(iOS 8.0, *)
public class UbiquitousStorage : AnyDynamicStorage {

    private let storage: NSUbiquitousKeyValueStore
    
    /// Initializes storage with `NSUbiquitousKeyValueStore.default` instance to be used internally.
    public convenience init() {
        self.init(ubiquitous: .default)
    }
    
    /// Initializes storage with provided `ubiquitous` instance to be used internally.
    public init(ubiquitous: NSUbiquitousKeyValueStore) {
        self.storage = ubiquitous
    }
    
    public func value(forKey key: String) -> Any? {
        return storage.value(forKey: key)
    }
    
    public func set(_ value: Any, forKey key: String) -> Bool {
        storage.set(value, forKey: key)
        return true
    }
    
    public func removeValue(forKey key: String) -> Bool {
        storage.removeObject(forKey: key)
        return true
    }
    
    public func removeAll() -> Bool {
        dictionary.keys.forEach {
            storage.removeObject(forKey: $0)
        }
        storage.synchronize()
        return true
    }
    
    public var count: Int {
        return dictionary.count
    }
    
    public var dictionary: [String : Any] {
        return storage.dictionaryRepresentation
    }
    
    deinit {
        storage.synchronize()
    }
}
