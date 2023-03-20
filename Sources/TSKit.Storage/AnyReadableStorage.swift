// - Since: 04/07/2017
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020-2023. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

/// Represents a common way to read values in storages of any kind.
public protocol AnyReadableStorage : AnyObject {
    
    /// Total number of stored entries.
    var count: Int { get }
    
    /// Checks whether the value, associated with given key, exists in storage.
    /// - Parameter key: Key associated with stored value.
    /// - Returns: Returns `true` if value exists.
    func hasValue(forKey key: String) -> Bool
}
