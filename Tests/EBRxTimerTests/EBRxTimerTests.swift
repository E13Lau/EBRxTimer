import XCTest
@testable import EBRxTimer

final class EBRxTimerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EBRxTimer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
