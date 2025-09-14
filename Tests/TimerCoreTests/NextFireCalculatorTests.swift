 
import XCTest
@testable import TimerCore

final class NextFireCalculatorTests: XCTestCase {
    func testNextDailyFuture() {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = cal.date(from: DateComponents(year: 2025, month: 1, day: 1, hour: 7, minute: 0))!
        let time = cal.date(from: DateComponents(year: 2020, month: 1, day: 1, hour: 8, minute: 0))!
        let alarm = Alarm(time: time, title: "毎日", repeatsDaily: true)

        let next = NextFireCalculator.nextFireDate(from: alarm, now: now, calendar: cal)!
        XCTAssertEqual(cal.component(.hour, from: next), 8)
        XCTAssertTrue(next > now)
    }
}
