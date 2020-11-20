// - Since: 04/07/2017
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

/// Represents a common way to read values in storages of any kind.
public protocol AnyReadableDynamicStorage : AnyReadableStorage {
    
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
