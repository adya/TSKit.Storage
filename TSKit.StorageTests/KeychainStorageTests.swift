import XCTest
import TSKit_Core
@testable import TSKit_Storage

class KeychainStorageTests: XCTestCase {
    
    let storage = KeychainStorage()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        storage.removeAll()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBoolIntegrity() {
        assertIntegrity(with: true)
        assertIntegrity(with: false)
    }
    
    func testIntIntegrity() {
        
        assertIntegrity(with: 5 as Int)
        assertIntegrity(with: -5 as Int)
        assertIntegrity(with: 0 as Int)
    }
    
    func testDeciamlIntegrity() {
        assertIntegrity(with: 5 as Decimal)
        assertIntegrity(with: 5.55 as Decimal)
    }
    
    func testDoubleIntegrity() {
        assertIntegrity(with: 5.55 as Double)
    }
    
    func testFloatIntegrity() {
        assertIntegrity(with: 5.55 as Float)
    }
    
    func testStringIntegrity() {
        assertIntegrity(with: "My text", key: "shortText")
        assertIntegrity(with: String.random(count: 1000), key: "longText")
        assertIntegrity(with: "", key: "emptyText")
    }
    
    func testRemoveAll() {
        let keys = ["First", "Second", "Third"]
        
        let allSet = keys.allSatisfy { set(true, forKey: $0) }
        
        assert(allSet, "Failed to set all values")
        assert(storage.count == keys.count, "Counts do not match")
        
        let allRemoved = storage.removeAll()
        let isEmpty = keys.allSatisfy { !storage.hasValue(forKey: $0) }
        
        assert(allRemoved, "Failed to remove all values")
        assert(isEmpty, "Storage is not empty after removing all values")
        assert(storage.count == 0, "Count is not zero for empty storage")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func assertIntegrity<T>(with value: T, key: String? = nil) {
        let key = key ?? "\(T.self)"
        assert(set(value, forKey: key), "Failed to set \(key) value")
        assert(match(value, forKey: key), "\(key) integrity not preserved")
    }
    
    private func set<T>(_ value: T, forKey key: String) -> Bool {
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
    
    private func match<T>(_ value: T, forKey key: String) -> Bool {
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
