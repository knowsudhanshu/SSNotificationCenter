import XCTest
@testable import SSNotificationCenter

final class SSNotificationCenterTests: XCTestCase {
    
    func testAddObserver() {
        SSNotificationCenter.shared.addObserver(self, notificationName: "Test") { name, obj in
            print("notification posted")
        }
        
        SSNotificationCenter.shared.addObserver(self, notificationName: "Test") { name, obj in
            print("notification posted 2")
        }
        
        let count = SSNotificationCenter.shared.observerCount(for: "Test")
        
        XCTAssert(count == 2)
    }
}
