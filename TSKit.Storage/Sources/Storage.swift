// - Since: 01/21/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

@available(*, renamed: "Storage")
/// Provides access to predefined storages.
public typealias Storages = Storage

/// Provides access to predefined storages.
public enum Storage {
    
    /// Local storage. Persistent throughout multiple app launches.
    public static let local: AnyDynamicStorage = UserDefaultsStorage()
    
    /// Temporary storage. Persistent throughout the app during single launch.
    public static let temp: AnyDynamicStorage = DictionaryStorage()
    
    /// Remote storage. Persistent throughout multiple devices connected to the same iCloud.
    public static let remote: AnyDynamicStorage = UbiquitousStorage()
    
    /// Secure local storage. Persistent throughout multiple app launches.
    /// Stored values can be accessed only through the application that saved these values.
    public static let secure: AnyTypedStorage = KeychainStorage()
    
    /// Plist storages. Read-only storages. Persistent for app build.
    public static func plist(named: String) -> AnyReadableDynamicStorage? {
        return PlistStorageContainer.storage(named: named)
    }
}

/// Caches multiple loaded plist storages.
private class PlistStorageContainer {
    
    private static var storages : [String : AnyReadableDynamicStorage] = [:]
    
    static func storage(named: String) -> AnyReadableDynamicStorage? {
        if let storage = storages[named] {
            return storage
        }
        
        guard let plist = PlistStorage(plistName: named) else { return nil }
       
        storages[named] = plist
        return plist
    }
}
