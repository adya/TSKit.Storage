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
    
    /// Identifier of the service that is attempting access to keychain.
    /// Defaults to `Bundle.main.bundleIdentifier` of the application iff it is available, otherwise to `"KeychainStorage"`.
    /// - Important: This identifier should be the same across whole application to ensure that all keys stored through this storage are accessible.
    /// - Note: [kSecAttrService](https://developer.apple.com/documentation/security/ksecattrservice)
    public let identifier: String
    
    /// Identifier for `Keychain Access Group` which this storage have access to.
    /// Access groups are used when multiple apps from the same vendor need to share keychain items.
    /// - Important: Requries enabling `Keychaing Sharing` capability in the host application.
    /// - Note: [kSecAttrAccessGroup](https://developer.apple.com/documentation/security/ksecattraccessgroup)
    public let accessGroup: String?
    
    /// Accessibility level that indicates when a keychain item is accessible.
    /// - Note: [kSecAttrAccessible](https://developer.apple.com/documentation/security/ksecattraccessible)
    public let accessibility: Accessibility
    
    public var count: Int {
        getAll().count
    }
    
    public init(identifier: String? = nil,
                accessibility: Accessibility = .whenUnlocked,
                accessGroup: String? = nil) {
        self.identifier = identifier ?? Bundle.main.bundleIdentifier ?? String(describing: KeychainStorage.self)
        self.accessibility = accessibility
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
                   kSecAttrService: identifier,
                   kSecAttrAccessible: accessibility.value
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

public extension KeychainStorage {
    
    /// Accessibility level that indicates when a keychain item is accessible.
    /// - Note: [kSecAttrAccessible](https://developer.apple.com/documentation/security/ksecattraccessible)
    enum Accessibility {
        
        /// The data in the keychain item can always be accessed regardless of whether the device is locked.
        ///
        /// **This is not recommended for application use.**
        /// - Important:
        ///     - Items with this attribute migrate to a new device when using encrypted backups.
        /// - Note: [kSecAttrAccessibleAlways](https://developer.apple.com/documentation/security/kSecAttrAccessibleAlways)
        @available(iOS, introduced: 4.0, deprecated: 12.0, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlock")
        case always
        
        /// The data in the keychain item can always be accessed regardless of whether the device is locked.
        ///
        /// **This is not recommended for application use.**
        /// - Important:
        ///     - Items with this attribute never migrate to a new device.
        ///     - After a backup is restored to a new device, these items are missing.
        /// - Note: [kSecAttrAccessibleAlwaysThisDeviceOnly](https://developer.apple.com/documentation/security/kSecAttrAccessibleAlwaysThisDeviceOnly)
        @available(iOS, introduced: 4.0, deprecated: 12.0, message: "Use an accessibility level that provides some user protection, such as afterFirstUnlockThisDeviceOnly")
        case alwaysThisDeviceOnly
        
        /// The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
        ///
        /// After the first unlock, the data remains accessible until the next restart.
        /// This is recommended for items that need to be accessed by background applications.
        /// - Important:
        ///     - Items with this attribute migrate to a new device when using encrypted backups.
        /// - Note: [kSecAttrAccessibleAfterFirstUnlock](https://developer.apple.com/documentation/security/kSecAttrAccessibleAfterFirstUnlock)
        case afterFirstUnlock
        
        /// The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
        ///
        /// After the first unlock, the data remains accessible until the next restart.
        /// This is recommended for items that need to be accessed by background applications.
        /// - Important:
        ///     - Items with this attribute never migrate to a new device.
        ///     - After a backup is restored to a new device, these items are missing.
        /// - Note: [kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly](https://developer.apple.com/documentation/security/kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        case afterFirstUnlockThisDeviceOnly
        
        /// The data in the keychain item can be accessed only while the device is unlocked by the user.
        /// This is the default value for keychain items added without explicitly setting an accessibility constant.
        ///
        /// This is recommended for items that need to be accessible only while the application is in the foreground.
        /// - Important:
        ///     - Items with this attribute migrate to a new device when using encrypted backups.
        /// - Note: [kSecAttrAccessibleWhenUnlocked](https://developer.apple.com/documentation/security/kSecAttrAccessibleWhenUnlocked)
        case whenUnlocked
        
        /// The data in the keychain item can be accessed only while the device is unlocked by the user.
        ///
        /// This is recommended for items that need to be accessible only while the application is in the foreground.
        /// - Important:
        ///     - Items with this attribute never migrate to a new device.
        ///     - After a backup is restored to a new device, these items are missing.
        /// - Note: [kSecAttrAccessibleWhenUnlockedThisDeviceOnly](https://developer.apple.com/documentation/security/kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        case whenUnlockedThisDeviceOnly
        
        /// The data in the keychain can only be accessed when the device is unlocked.
        /// **Only available if a passcode is set on the device**.
        ///
        /// This is recommended for items that only need to be accessible while the application is in the foreground.
        /// - Important:
        ///     - Items with this attribute never migrate to a new device.
        ///     - After a backup is restored to a new device, these items are missing.
        ///     - No items can be stored in this class on devices without a passcode.
        /// - Attention: Disabling the device passcode causes all items in this class to be deleted.
        /// - Note: [kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly](https://developer.apple.com/documentation/security/kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
        case whenPasscodeSetThisDeviceOnly
        
        var value: CFString {
            switch self {
                case .always: return kSecAttrAccessibleAlways
                case .whenUnlocked: return kSecAttrAccessibleWhenUnlocked
                case .afterFirstUnlock: return kSecAttrAccessibleAfterFirstUnlock
                case .alwaysThisDeviceOnly: return kSecAttrAccessibleAlwaysThisDeviceOnly
                case .whenUnlockedThisDeviceOnly: return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
                case .whenPasscodeSetThisDeviceOnly: return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
                case .afterFirstUnlockThisDeviceOnly: return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            }
        }
    }
}
