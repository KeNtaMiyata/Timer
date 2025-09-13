import XCTest
@testable import TimerCore

final class TimerCoreTests: XCTestCase {
    func testSanity() {
        XCTAssertTrue(true)
    }

    func testFormat() {
        let c = Countdown()
        XCTAssertEqual(c.format(seconds: 125), "02:05")
        XCTAssertEqual(c.format(seconds: 0), "00:00")
    }
}