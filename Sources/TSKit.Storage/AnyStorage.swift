// - Since: 04/07/2017
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

/// Represents a common way to access (read/write) values in storages of any kind.
public protocol AnyStorage : AnyReadableStorage {
    
    /// Removes an object associated with specified `key`.
    /// - Parameter key: Key associated with stored value.
    /// - Returns: `true` if value has been removed, otherwise `false`.
    @discardableResult
    func removeValue(forKey key: String) -> Bool
    
    /// Removes all stored values.
    @discardableResult
    func removeAll() -> Bool
}
