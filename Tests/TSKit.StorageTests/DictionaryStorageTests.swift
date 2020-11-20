import XCTest
@testable import TSKit_Storage

class DictionaryTypedStorageTests: TypedStorageTests {

    private let dictionaryStorage = DictionaryStorage()
    
    override var storage: AnyTypedStorage { dictionaryStorage }
}
