/// - Since: 01/21/2018
/// - Author: Arkadii Hlushchevskyi
/// - Copyright: © 2018. Arkadii Hlushchevskyi.
/// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

import TSKit_Core

/// Merges multiple storages into one.
class MergedStorage : AnyReadableStorage {
    
    private let storages : [AnyReadableStorage]
    
    init(storages: [AnyReadableStorage]) {
        self.storages = storages
    }
    
    func value(forKey key: String) -> Any? {
        for storage in storages {
            if let value = storage[key] {
                return value
            }
        }
        return nil
    }
   
    var count: Int {
        return storages.reduce(0) { $0 + $1.count }
    }
    
    var dictionary: [String : Any] {
        return storages.reduce([:]) { $0 + $1.dictionary }
    }
}
