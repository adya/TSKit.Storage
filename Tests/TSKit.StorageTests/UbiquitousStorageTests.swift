import XCTest
@testable import TSKit_Storage

class UbiquitousStorageTests: TypedStorageTests {

    private let ubiquitousStorage = UbiquitousStorage()
    
    override var storage: AnyTypedStorage { ubiquitousStorage }
}
