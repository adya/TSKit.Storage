// - Since: 04/20/2020
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020-2023. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation

/// Represents a common way to access (read/write) values in storages of any kind.
public protocol AnyTypedStorage : AnyStorage, AnyReadableTypedStorage {
     
    @discardableResult
    func set(_ value: String, forKey key: String) -> Bool
    
    @discardableResult
    func set(_ value: Int, forKey key: String) -> Bool
    
    @discardableResult
    func set(_ value: Decimal, forKey key: String) -> Bool
    
    @discardableResult
    func set(_ value: Double, forKey key: String) -> Bool
    
    @discardableResult
    func set(_ value: Float, forKey key: String) -> Bool
    
    @discardableResult
    func set(_ value: Bool, forKey key: String) -> Bool
    
    @discardableResult
    func set(_ value: NSNumber, forKey key: String) -> Bool
    
    @discardableResult
    func set(_ value: Data, forKey key: String) -> Bool
   
}

// MARK: - Pop values add-on
public extension AnyTypedStorage {
    
    /// Retrieves `String` value associated with given `key` and removes it from the storage.
    /// - Parameter key: Key associated with stored value.
    /// - Returns:`String` value associated with the `key` if exists or `nil` otherwise.
    func popStringValue(forKey key: String) -> String? {
        defer { removeValue(forKey: key) }
        return stringValue(forKey: key)
    }
    
    /// Retrieves `Int` value associated with given `key` and removes it from the storage.
    /// - Parameter key: Key associated with stored value.
    /// - Returns:`Int` value associated with the `key` if exists or `nil` otherwise.
    func popIntValue(forKey key: String) -> Int? {
        defer { removeValue(forKey: key) }
        return intValue(forKey: key)
    }
    
    /// Retrieves `Double` value associated with given `key` and removes it from the storage.
    /// - Parameter key: Key associated with stored value.
    /// - Returns:`Double` value associated with the `key` if exists or `nil` otherwise.
    func popDoubleValue(forKey key: String) -> Double? {
        defer { removeValue(forKey: key) }
        return doubleValue(forKey: key)
    }
    
    /// Retrieves `Float` value associated with given `key` and removes it from the storage.
    /// - Parameter key: Key associated with stored value.
    /// - Returns:`Float` value associated with the `key` if exists or `nil` otherwise.
    func popFloatValue(forKey key: String) -> Float? {
        defer { removeValue(forKey: key) }
        return floatValue(forKey: key)
    }
    
    /// Retrieves `Decimal` value associated with given `key` and removes it from the storage.
    /// - Parameter key: Key associated with stored value.
    /// - Returns:`Decimal` value associated with the `key` if exists or `nil` otherwise.
    func popDecimalValue(forKey key: String) -> Decimal? {
        defer { removeValue(forKey: key) }
        return decimalValue(forKey: key)
    }
    
    /// Retrieves `Bool` value associated with given `key` and removes it from the storage.
    /// - Parameter key: Key associated with stored value.
    /// - Returns:`Bool` value associated with the `key` if exists or `nil` otherwise.
    func popBoolValue(forKey key: String) -> Bool? {
        defer { removeValue(forKey: key) }
        return boolValue(forKey: key)
    }
    
    /// Retrieves `NSNumber` value associated with given `key` and removes it from the storage.
    /// - Parameter key: Key associated with stored value.
    /// - Returns:`NSNumber` value associated with the `key` if exists or `nil` otherwise.
    func popNumberValue(forKey key: String) -> NSNumber? {
        defer { removeValue(forKey: key) }
        return numberValue(forKey: key)
    }
    
    /// Retrieves `Data` value associated with given `key` and removes it from the storage.
    /// - Parameter key: Key associated with stored value.
    /// - Returns:`Data` value associated with the `key` if exists or `nil` otherwise.
    func popDataValue(forKey key: String) -> Data? {
        defer { removeValue(forKey: key) }
        return dataValue(forKey: key)
    }
}


