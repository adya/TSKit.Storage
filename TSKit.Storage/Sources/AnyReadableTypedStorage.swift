// - Since: 04/20/2020
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

/// Represents a common way to read values in storages of any kind in a typed manner.
public protocol AnyReadableTypedStorage : AnyReadableStorage {
 
    func stringValue(forKey key: String) -> String?
    
    func intValue(forKey key: String) -> Int?
    
    func doubleValue(forKey key: String) -> Double?
    
    func floatValue(forKey key: String) -> Float?
    
    func decimalValue(forKey key: String) -> Decimal?
    
    func boolValue(forKey key: String) -> Bool?
    
    func numberValue(forKey key: String) -> NSNumber?
    
    func dataValue(forKey key: String) -> Data?
}
