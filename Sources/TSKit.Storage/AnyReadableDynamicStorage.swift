// - Since: 04/07/2017
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020-2023. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation

/// Represents a common way to read values in storages of any kind.
public protocol AnyReadableDynamicStorage : AnyReadableTypedStorage {
    
    /// Convenient way to access stored values.
    /// - Parameter key: Key associated with stored value.
    subscript(key : String) -> Any? { get }
    
    /// Dictionary representation of the storage.
    var dictionary : [String : Any] { get }
    
    /// Gets value associated with given key.
    /// - Parameter key: Key associated with a value.
    /// - Returns: Returns a value if any or `nil`.
    func value(forKey key: String) -> Any?
}

// MARK: - Defaults
public extension AnyReadableDynamicStorage {
    
    subscript(key : String) -> Any? {
        value(forKey: key)
    }
    
    func hasValue(forKey key: String) -> Bool {
        value(forKey: key) != nil
    }
}

// MARK: - Typed support for dynamic storages
public extension AnyReadableDynamicStorage {
    
    func stringValue(forKey key: String) -> String? {
        value(forKey: key) as? String
    }
    
    func intValue(forKey key: String) -> Int? {
        value(forKey: key) as? Int
    }
    
    func doubleValue(forKey key: String) -> Double? {
        value(forKey: key) as? Double
    }
    
    func floatValue(forKey key: String) -> Float? {
        value(forKey: key) as? Float
    }
    
    func decimalValue(forKey key: String) -> Decimal? {
        value(forKey: key) as? Decimal
    }
    
    func boolValue(forKey key: String) -> Bool? {
        value(forKey: key) as? Bool
    }
    
    func numberValue(forKey key: String) -> NSNumber? {
        value(forKey: key) as? NSNumber
    }
    
    func dataValue(forKey key: String) -> Data? {
        value(forKey: key) as? Data
    }
}
