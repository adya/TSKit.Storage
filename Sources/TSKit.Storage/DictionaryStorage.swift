// - Since: 01/21/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation

public class DictionaryStorage : AnyDynamicStorage, AnyTypedStorage {
    
    private var storage = [String : Any]()
    
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

// MARK: - Setters
public extension DictionaryStorage {
    
    func set(_ value: String, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }
    
    func set(_ value: Int, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }
    
    func set(_ value: Decimal, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }
    
    func set(_ value: Double, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }
    
    func set(_ value: Float, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }
    
    func set(_ value: Bool, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }
    
    func set(_ value: NSNumber, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }
    
    func set(_ value: Data, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }
    
}

public extension DictionaryStorage {
    
    func stringValue(forKey key: String) -> String? {
        storage[key] as? String
    }
    
    func intValue(forKey key: String) -> Int? {
        storage[key] as? Int
    }
    
    func doubleValue(forKey key: String) -> Double? {
        storage[key] as? Double
    }
    
    func floatValue(forKey key: String) -> Float? {
        storage[key] as? Float
    }
    
    func decimalValue(forKey key: String) -> Decimal? {
        storage[key] as? Decimal
    }
    
    func boolValue(forKey key: String) -> Bool? {
        storage[key] as? Bool
    }
    
    func numberValue(forKey key: String) -> NSNumber? {
        storage[key] as? NSNumber
    }
    
    func dataValue(forKey key: String) -> Data? {
        storage[key] as? Data
    }
}
