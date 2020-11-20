// - Since: 04/20/2020
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

/// Represents a common way to access (read/write) values in storages of any kind.
public protocol AnyDynamicStorage : AnyStorage, AnyReadableDynamicStorage {
    
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
            return value(forKey: key)
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
