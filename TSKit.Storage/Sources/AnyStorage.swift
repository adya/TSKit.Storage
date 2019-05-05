/// - Since: 01/21/2018
/// - Author: Arkadii Hlushchevskyi
/// - Copyright: © 2018. Arkadii Hlushchevskyi.
/// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

/**
 Represents a common way to access (read/write) values in storages of any kind.
 
 - Version: 1.0
 - Since:   04/07/2017
 - Author:  AdYa
 */
public protocol AnyStorage : AnyReadableStorage {
    
    /// Gets or sets value for given key.
    /// - Note: Passing `nil` is equivalent to `removeValue(for:)`
    /// - Parameter key: Key associated with a value.
    subscript(key : String) -> Any? {get set}
    
    /**
     Saves the value in storage and associates it with given key.
     - Parameter value: Value to be saved.
     - Parameter key: Key associated with given value.
     - Returns: Flag indicating whether value has been set or not.
     */
    @discardableResult
    func set(_ value: Any, forKey key: String) -> Bool
    
    /**
     Loads value, associated with given key, and if exists - removes it from the storage.
     - Parameter key: Key associated with a value.
     - Returns: Returns value if any or `nil`.
     */
    func popValue(forKey key: String) -> Any?
    
    /**
     Removes object associated with specified key.
     - Parameter key: Key associated with a value.
     - Returns: Flag indicating whether value has been removed or not.
     */
    @discardableResult
    func removeValue(forKey key: String) -> Bool
    
    /// Removes all stored values.
    @discardableResult
    func removeAll() -> Bool
}

public extension AnyStorage {
    
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
    
    func popValue(forKey key: String) -> Any? {
        let value = self.value(forKey: key)
        _ = removeValue(forKey: key)
        return value
    }
}
