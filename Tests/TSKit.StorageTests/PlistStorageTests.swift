import XCTest
@testable import TSKit_Storage

class PlistStorageTests: TypedStorageTests {
    
    var plistPath: URL {
        try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("PlistStorage", isDirectory: false)
            .appendingPathExtension("plist")
    }
    
    private var plistStorage: PlistStorage!
    
    override func setUp() {
        plistStorage = try! .init(plistPath: plistPath)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(at: plistPath)
    }
    
    override var storage: AnyTypedStorage { plistStorage }
    
    func testFileStorageIsAutomaticallySynced() {
        plistStorage.set(true, forKey: "StorageWorking")
        
        let expectation = expectation(description: "Wait for async write to happen")
        print("\(plistStorage.dictionary)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.plistStorage.set(0, forKey: "StorageValue1")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.plistStorage.set("Latest", forKey: "StorageValue2")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.1, handler: nil)
    }
    
    func testFileStorageIsWrittenOnDeinit() {
        let key = "DeinitingValue"
        let value = true
        plistStorage.set(value, forKey: key)
        plistStorage = nil
        plistStorage = try! .init(plistPath: plistPath)
        
        XCTAssertEqual(plistStorage.boolValue(forKey: key), value, "Re-initialized storage should load correct value from file storage")
    }
    
    func testPlistStorageIsInitializedWithContentsOfBackingFile() {
        let date = Date()
        let plist: [String: Any] = ["int": 3,
                                    "float": 3.5,
                                    "string": "text",
                                    "data": Data([0x11, 0x22, 0x33, 0x44]),
                                    "date": date,
                                    "dictionary": ["nestedInt": 2],
                                    "intArray": [1, 2, 3],
                                    "stringArray": ["text1", "text2"]]
        
        plistStorage.setValues(from: plist)
        plistStorage = nil
        
        plistStorage = try! .init(plistPath: plistPath)
        
        XCTAssertEqual(plistStorage["int"] as? Int, plist["int"] as? Int, "Storage should contain the same values as written before")
        XCTAssertEqual(plistStorage["float"] as? Double, plist["float"] as? Double, "Storage should contain the same values as written before")
        XCTAssertEqual(plistStorage["string"] as? String, plist["string"] as? String, "Storage should contain the same values as written before")
        XCTAssertEqual(plistStorage["data"] as? Data, plist["data"] as? Data, "Storage should contain the same values as written before")
        // Date in the storage preserves the time with seconds granularity, so the date used in the test should be floored to truncate fractions of a second.
        XCTAssertEqual((plistStorage["date"] as? Date).flatMap { $0.timeIntervalSince1970 },
                       (plist["date"] as? Date).flatMap { floor($0.timeIntervalSince1970) },
                       "Storage should contain the same values as written before")
        XCTAssertEqual(plistStorage["intArray"] as? [Int], plist["intArray"] as? [Int], "Storage should contain the same values as written before")
        XCTAssertEqual(plistStorage["stringArray"] as? [String], plist["stringArray"] as? [String], "Storage should contain the same values as written before")
        XCTAssertEqual(plistStorage["dictionary"] as? [String: Int], plist["dictionary"] as? [String: Int], "Storage should contain the same values as written before")
    }
}
