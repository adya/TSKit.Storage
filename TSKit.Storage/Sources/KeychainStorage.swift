// - Since: 04/20/2020
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import Foundation
import CoreFoundation
import Security
import TSKit_Core

/// `Keychain` storage data source.
public class KeychainStorage : AnyTypedStorage {
   
    /// Identifier of the service that is attempting access to Keychain.
    /// - Important: This identifier should be the same across whole application to ensure that all keys stored through this storage are accessible.
    /// - Note: [kSecAttrService](https://developer.apple.com/documentation/security/ksecattrservice)
    public let identifier: String
    
    /// Identifier for `Keychain Access Group` which this storage have access to.
    /// - Note: [kSecAttrAccessGroup](https://developer.apple.com/documentation/security/ksecattraccessgroup)
    public let accessGroup: String?
    
    public var count: Int {
        getAll().count
    }
    
    public init(identifier: String? = nil, accessGroup: String? = nil) {
        self.identifier = identifier ?? Bundle.main.bundleIdentifier ?? String(describing: KeychainStorage.self)
        self.accessGroup = accessGroup
    }
    
    public func hasValue(forKey key: String) -> Bool {
        getValue(forKey: key) != nil
    }
    
    @discardableResult
    public func removeValue(forKey key: String) -> Bool {
        deleteValue(forKey: key)
    }
    
    @discardableResult
    public func removeAll() -> Bool {
        deleteAll()
    }
}

// MARK: - Typed setters
public extension KeychainStorage {
    
    @discardableResult
    func set(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return add(data, forKey: key)
    }
    
    @discardableResult
    func set(_ value: Int, forKey key: String) -> Bool {
        set(NSNumber(value: value), forKey: key)
    }
    
    @discardableResult
    func set(_ value: Double, forKey key: String) -> Bool {
        set(NSNumber(value: value), forKey: key)
    }
    
    @discardableResult
    func set(_ value: Decimal, forKey key: String) -> Bool {
        set(NSDecimalNumber(decimal: value), forKey: key)
    }
    
    @discardableResult
    func set(_ value: Float, forKey key: String) -> Bool {
        set(NSNumber(value: value), forKey: key)
    }
    
    @discardableResult
    func set(_ value: Bool, forKey key: String) -> Bool {
        set(NSNumber(value: value), forKey: key)
    }
    
    @discardableResult
    func set(_ value: NSNumber, forKey key: String) -> Bool {
        add(value, forKey: key)
    }
    
    @discardableResult
    func set(_ value: Data, forKey key: String) -> Bool {
        add(value, forKey: key)
    }
}

// MARK: - Typed getters
public extension KeychainStorage {
    
    func stringValue(forKey key: String) -> String? {
        dataValue(forKey: key).flatMap { String(data: $0, encoding: .utf8) }
    }
    
    func intValue(forKey key: String) -> Int? {
        numberValue(forKey: key)?.intValue
    }
    
    func decimalValue(forKey key: String) -> Decimal? {
        numberValue(forKey: key)?.decimalValue
    }
    
    func doubleValue(forKey key: String) -> Double? {
        numberValue(forKey: key)?.doubleValue
    }
    
    func floatValue(forKey key: String) -> Float? {
        numberValue(forKey: key)?.floatValue
    }
    
    func boolValue(forKey key: String) -> Bool? {
        numberValue(forKey: key)?.boolValue
    }
    
    func numberValue(forKey key: String) -> NSNumber? {
        dataValue(forKey: key).flatMap(NSKeyedUnarchiver.unarchiveObject(with:)) as? NSNumber
    }
    
    func dataValue(forKey key: String) -> Data? {
        getValue(forKey: key)
    }
}

// MARK: - Keychain API
private extension KeychainStorage {
    
    var defaultQuery: [CFString: Any] {
        transform([kSecClass: kSecClassGenericPassword,
                   kSecAttrService: identifier
        ]) {
            if let group = accessGroup {
                $0[kSecAttrAccessGroup] = group
            }
        }
    }
    
    func query(forKey key: String) -> [CFString: Any] {
        transform(defaultQuery) {
            $0[kSecAttrGeneric] = key.data(using: .utf8)
            $0[kSecAttrAccount] = key
        }
    }
    
    func update(_ value: Data, forKey key: String) -> Bool {
        SecItemUpdate(query(forKey: key) as CFDictionary,
                      [kSecValueData: value] as CFDictionary) == errSecSuccess
    }
    
    func add(_ value: Data, forKey key: String) -> Bool {
        let query = transform(self.query(forKey: key)) {
            $0[kSecValueData] = value
        }
        var res: AnyObject?
        switch SecItemAdd(query as CFDictionary, &res) {
            case errSecSuccess: return true
            case errSecDuplicateItem: return update(value, forKey: key)
            default: return false
        }
    }
    
    func add(_ value: NSCoding, forKey key: String) -> Bool {
        add(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
    }
    
    func getValue(forKey key: String) -> Data? {
        let query = transform(self.query(forKey: key)) {
            $0[kSecReturnData] = kCFBooleanTrue
        }
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess else { return nil }
        
        return result as? Data
    }
    
    func deleteValue(forKey key: String) -> Bool {
        SecItemDelete(query(forKey: key) as CFDictionary) == errSecSuccess
    }
    
    func deleteAll() -> Bool {
        SecItemDelete(defaultQuery as CFDictionary) == errSecSuccess
    }
    
    func getAll() -> [String: Data] {
        let query = transform(defaultQuery) {
            $0[kSecReturnAttributes] = kCFBooleanTrue
            $0[kSecMatchLimit] = kSecMatchLimitAll
            $0[kSecReturnRef] = kCFBooleanTrue
        }
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
            let items = result as? [[CFString: Any]] else { return [:] }
        
        return items.compactMap(key: { $0[kSecAttrAccount] as? String },
                                value: { $0[kSecValueData] as? Data })
        
    }
}
