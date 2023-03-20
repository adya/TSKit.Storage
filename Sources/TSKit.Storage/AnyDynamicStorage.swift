// - Since: 04/20/2020
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020-2023. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation

/// Represents a common way to access (read/write) values in storages of any kind.
public protocol AnyDynamicStorage : AnyTypedStorage, AnyReadableDynamicStorage {
    
    /// Gets or sets value for given `key`.
    /// - Note: Passing `nil` is equivalent to `removeValue(for:)`
    /// - Parameter key: Key associated with stored value.
    /// - Returns: Value associated with the `key` if exists or `nil` otherwise.
    subscript(key : String) -> Any? { get set }
    
    /**
     Saves the value in storage and associates it with given key.
     - Parameter value: Value to be saved.
     - Parameter key: Key associated with given value.
     - Returns: Flag indicating whether value has been set or not.
     */
    @discardableResult
    func set(_ value: Any, forKey key: String) -> Bool
    
    /// Sets all values containing in the `given` dictionary to the storage.
    ///
    /// If storage already contains value for a key present in the `dictionary`
    /// the value is overwritten by the `dictionary`.
    func setValues(from dictionary: [String: Any])
}

// MARK: - Pop values add-on
public extension AnyDynamicStorage {

    /// Retrieves a value associated with given `key` and removes it from the storage.
    /// - Parameter key: Key associated with stored value.
    /// - Returns: Value associated with the `key` if exists or `nil` otherwise.
    func popValue(forKey key: String) -> Any? {
        let value = self.value(forKey: key)
        _ = removeValue(forKey: key)
        return value
    }
}

public extension AnyDynamicStorage {
    
    subscript(key : String) -> Any? {
        get {
            value(forKey: key)
        }
        set {
            if let newValue = newValue {
                set(newValue, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }
}

// MARK: - Typed support for dynamic storages
public extension AnyDynamicStorage {
    
    @discardableResult
    func set(_ value: String, forKey key: String) -> Bool {
        set(value as Any, forKey: key)
    }
    
    @discardableResult
    func set(_ value: Int, forKey key: String) -> Bool {
        set(value as Any, forKey: key)
    }
    
    @discardableResult
    func set(_ value: Decimal, forKey key: String) -> Bool {
        set(value as Any, forKey: key)
    }
    
    @discardableResult
    func set(_ value: Double, forKey key: String) -> Bool {
        set(value as Any, forKey: key)
    }
    
    @discardableResult
    func set(_ value: Float, forKey key: String) -> Bool {
        set(value as Any, forKey: key)
    }
    
    @discardableResult
    func set(_ value: Bool, forKey key: String) -> Bool {
        set(value as Any, forKey: key)
    }
    
    @discardableResult
    func set(_ value: NSNumber, forKey key: String) -> Bool {
        set(value as Any, forKey: key)
    }
    
    @discardableResult
    func set(_ value: Data, forKey key: String) -> Bool {
        set(value as Any, forKey: key)
    }
}

public extension AnyDynamicStorage {
    
    func setValues(from dictionary: [String: Any]) {
        dictionary.forEach { key, value in
            set(value, forKey: key)
        }
    }
}
