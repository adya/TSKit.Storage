import XCTest
@testable import TSKit_Storage

class KeychainStorageTests: TypedStorageTests {

    private let keychainStorage = KeychainStorage()
    
    override var storage: AnyTypedStorage { keychainStorage }
}
