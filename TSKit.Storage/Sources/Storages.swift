/// Provides access to predefined storages.
public enum Storages {
    
    /// Local storage. Persistent throughout multiple app launches.
    public static let local : AnyStorage = UserDefaultsStorage()
    
    /// Temporary storage. Persistent throughout the app during single launch.
    public static let temp : AnyStorage = DictionaryStorage()
    
    /// Remote storage. Persistent throughout multiple devices connected to the same iCloud.
    public static let remote : AnyStorage = UbiquitousStorage()
    
    /// Plist storages. Read-only storages. Persistent for app build.
    public static func plist(named: String) -> AnyReadableStorage? {
        return PlistStorageContainer.storage(named: named)
    }
}

/// Caches multiple loaded plist storages.
private class PlistStorageContainer {
    private static var storages : [String : AnyReadableStorage] = [:]
    
    static func storage(named: String) -> AnyReadableStorage? {
        if let storage = storages[named] {
            return storage
        }
        
        guard let plist = PlistStorage(plistName: named) else { return nil }
       
        storages[named] = plist
        return plist
    }
}
