import XCTest
@testable import TemplateApp

final class WelcomeTests: XCTestCase {

    /// A fixed clock, because a test that greets differently at 6pm is not
    /// a test.
    private func welcome(atHour hour: Int) -> Welcome {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let date = calendar.date(from: DateComponents(year: 2026, month: 8, day: 15, hour: hour))!
        return Welcome(now: date, calendar: calendar)
    }

    func testGreetingChangesThroughTheDay() {
        XCTAssertEqual(welcome(atHour: 8).greeting, "Good morning")
        XCTAssertEqual(welcome(atHour: 14).greeting, "Good afternoon")
        XCTAssertEqual(welcome(atHour: 20).greeting, "Good evening")
        XCTAssertEqual(welcome(atHour: 3).greeting, "Good night")
    }

    func testBoundariesBelongToTheLaterPeriod() {
        XCTAssertEqual(welcome(atHour: 4).greeting, "Good night")
        XCTAssertEqual(welcome(atHour: 5).greeting, "Good morning")
        XCTAssertEqual(welcome(atHour: 12).greeting, "Good afternoon")
        XCTAssertEqual(welcome(atHour: 18).greeting, "Good evening")
        XCTAssertEqual(welcome(atHour: 22).greeting, "Good night")
    }

    func testMessageNamesTheApp() {
        XCTAssertEqual(welcome(atHour: 9).message(for: "TemplateApp"), "Good morning — this is TemplateApp.")
    }
}
