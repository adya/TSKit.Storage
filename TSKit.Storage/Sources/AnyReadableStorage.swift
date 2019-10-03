/// - Since: 01/21/2018
/// - Authors: Arkadii Hlushchevskyi
/// - Copyright: © 2018. Arkadii Hlushchevskyi.
/// - Seealsos: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

/**
 Represents a common way to read values in storages of any kind.
 
 - Version: 1.0
 - Since:   04/07/2017
 - Author:  AdYa
 */
public protocol AnyReadableStorage : class {
    
    /** 
     Convinient way to access stored values.
     - Parameter key: Key associated with a value.
     */
    subscript(key : String) -> Any? {get}
    
    /// Returns total number of stored entries.
    var count : Int {get}
    
    /// Returns dictionary representation of the storage.
    var dictionary : [String : Any] {get}
    
    /** 
     Gets value associated with given key.
     - Parameter key: Key associated with a value.
     - Returns: Returns a value if any or `nil`.
     */
    func value(forKey key: String) -> Any?
    
    /**
     Checks whether the value, associated with given key, exists in storage.
     - Parameter key: Key associated with a value.
     - Returns: Returns `true` if value exists.
     */
    func hasValue(forKey key: String) -> Bool

}

public extension AnyReadableStorage {
    
    subscript(key : String) -> Any? {
        return value(forKey: key)
    }
    
    func hasValue(forKey key: String) -> Bool {
        return value(forKey: key) != nil
    }
}
