import XCTest
import TSKit_Core
@testable import TSKit_Storage

class TypedStorageTests: XCTestCase {
        
    var storage: AnyTypedStorage {
        fatalError("Provide storage instance to be tested")
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        storage.removeAll()
        super.tearDown()
    }
}

// MARK: - Setter
extension TypedStorageTests {
    
    func testBoolIntegrity() {
        assertIntegrity(with: true)
        assertIntegrity(with: false)
    }
    
    func testIntIntegrity() {
        assertIntegrity(with: 5)
        assertIntegrity(with: Int.min)
        assertIntegrity(with: Int.max)
    }
    
    func testDecimalIntegrity() {
        assertIntegrity(with: 5 as Decimal)
        assertIntegrity(with: 5.55 as Decimal)
    }
    
    func testDoubleIntegrity() {
        assertIntegrity(with: 5.55 as Double)
    }
    
    func testFloatIntegrity() {
        assertIntegrity(with: 5.55 as Float)
    }
    
    func testDataIntegrity() {
        assertIntegrity(with: Data(bytes: [0x11, 0x22, 0x33, 0x44]))
    }
    
    func testStringIntegrity() {
        assertIntegrity(with: "My text", key: "shortText")
        assertIntegrity(with: String(repeating: "a", count: 1000), key: "longText")
        assertIntegrity(with: "", key: "emptyText")
    }
}

// MARK: - Updates
extension TypedStorageTests {
    
    func testUpdate() {
        let key = "Value"
        guaranteedSet(true, forKey: key)
        
        assertIntegrity(with: false, key: key)
    }
}

// MARK: - Value testing
extension TypedStorageTests {
    
    func testHasValue() {
        let key = "Value"
        
        XCTAssertFalse(storage.hasValue(forKey: key), "Storage must not contain value for key '\(key)' prior to it being set")
        
        guaranteedSet(true, forKey: key)
        
        XCTAssertTrue(storage.hasValue(forKey: key), "Storage should contain value for key '\(key)' after it was set")
        XCTAssertFalse(storage.hasValue(forKey: "UnrelatedValue"), "Storage must not contain unrelated values that was not stored in it")
        
        guaranteedRemove(forKey: key)
        XCTAssertFalse(storage.hasValue(forKey: key), "Storage must not contain value for key '\(key)' after it was removed")
        
    }
    
    func testCount() {
        let keys = ["First", "Second", "Third"]
        let modifiedKey = keys.first!
        
        guaranteedPopulateValues(forKeys: keys)
        
        XCTAssertEqual(storage.count, keys.count, "Count doesn't match number of added items")
        
        guaranteedSet(true, forKey: modifiedKey)
        
        XCTAssertEqual(storage.count, keys.count, "Count must remain the same after updating existing value")
        
        guaranteedRemove(forKey: modifiedKey)
        
        XCTAssertEqual(storage.count, keys.count - 1, "Count must be decremented after removing a single value")
        
        guaranteedRemoveAll()
        
        XCTAssertEqual(storage.count, 0, "storage.count must be `0` after removing all values")
    }
}

// MARK: - Removals
extension TypedStorageTests {
    
    func testRemoveAll() {
        let keys = ["First", "Second", "Third"]
        guaranteedPopulateValues(forKeys: keys)
        
        let allRemoved = storage.removeAll()
        let isEmpty = keys.allSatisfy { !storage.hasValue(forKey: $0) }
        
        XCTAssertTrue(allRemoved, "Failed to remove all values")
        XCTAssertTrue(isEmpty, "Storage is not empty after removing all values")
    }
    
    func testRemove() {
        let toBeRemovedKey = "Value"
        let toBeRetainedKey = "IntValue"
        let retainedValue = 5
        storage.set(true, forKey: toBeRemovedKey)
        storage.set(retainedValue, forKey: toBeRetainedKey)
        
        let wasRemoved = storage.removeValue(forKey: toBeRemovedKey)
        
        XCTAssertTrue(wasRemoved, "Failed to remove value for '\(toBeRemovedKey)' key")
        XCTAssertFalse(storage.hasValue(forKey: toBeRemovedKey), "Value is still present in the storage")
        XCTAssertEqual(storage.intValue(forKey: toBeRetainedKey), retainedValue, "Removal has affected unrelated value")
    }
}

private extension TypedStorageTests {
    
    /// Asserts that specifief `value` won't be modified when being stored and read afterwards.
    func assertIntegrity<T>(with value: T, key: String? = nil) {
        let key = key ?? "\(T.self)"
        XCTAssertTrue(set(value, forKey: key), "Failed to set \(key) value")
        XCTAssertTrue(match(value, forKey: key), "\(key) integrity not preserved")
    }
    
    func set<T>(_ value: T, forKey key: String) -> Bool {
        switch value {
            case let value as String: return storage.set(value, forKey: key)
            case let value as Int: return storage.set(value, forKey: key)
            case let value as Decimal: return storage.set(value, forKey: key)
            case let value as Double: return storage.set(value, forKey: key)
            case let value as Float: return storage.set(value, forKey: key)
            case let value as Bool: return storage.set(value, forKey: key)
            case let value as Data: return storage.set(value, forKey: key)
            case let value as NSNumber: return storage.set(value, forKey: key)
            default: return false
        }
    }
    
    func match<T>(_ value: T, forKey key: String) -> Bool {
        switch value {
            case let value as String: return storage.stringValue(forKey: key) == value
            case let value as Int: return storage.intValue(forKey: key) == value
            case let value as Decimal: return storage.decimalValue(forKey: key) == value
            case let value as Double: return storage.doubleValue(forKey: key) == value
            case let value as Float: return storage.floatValue(forKey: key) == value
            case let value as Bool: return storage.boolValue(forKey: key) == value
            case let value as Data: return storage.dataValue(forKey: key) == value
            case let value as NSNumber: return storage.numberValue(forKey: key) == value
            default: return false
        }
    }
}

// MARK: - Guaranteed calls
private extension TypedStorageTests {
    
    /// Populates storage with `true` values for specified keys.
    func guaranteedPopulateValues(forKeys keys: [String]) {
        XCTAssertTrue(keys.allSatisfy { set(true, forKey: $0) }, "`storage.set(_:,forKey:)` is malfunctioning")
    }
    
    func guaranteedRemove(forKey key: String) {
        XCTAssert(storage.removeValue(forKey: key), "`storage.removeValue(forKey:)` is malfunctioning")
    }
    
    func guaranteedRemoveAll() {
        XCTAssertTrue(storage.removeAll(), "`storage.removeAll()` is malfunctioning")
    }
    
    func guaranteedSet<T>(_ value: T, forKey key: String) {
        XCTAssertTrue(set(value, forKey: key), "`storage.set(_:,forKey:)` is malfunctioning")
    }
}
