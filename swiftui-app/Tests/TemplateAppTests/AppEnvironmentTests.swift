import XCTest
@testable import TemplateApp

/// Proves the profiles are wired, not decorative.
///
/// Every profile's values are asserted, not just the compiled one — the enum
/// is plain data precisely so a single test run can cover all three.
final class AppEnvironmentTests: XCTestCase {

    func testEachProfileDeclaresItsOwnName() {
        for environment in AppEnvironment.allCases {
            XCTAssertEqual(environment.rawValue, "\(environment)")
        }
    }

    func testDevelopmentPointsAtALocalAPIAndKeepsDetailOn() {
        let development = AppEnvironment.development

        XCTAssertEqual(development.apiBaseURL.host(), "localhost")
        XCTAssertTrue(development.verboseErrors)
        XCTAssertEqual(development.cacheSeconds, 0)
    }

    func testProductionPointsElsewhereAndTurnsDetailOff() {
        let production = AppEnvironment.production

        XCTAssertEqual(production.apiBaseURL.scheme, "https")
        XCTAssertFalse(production.verboseErrors)
        XCTAssertEqual(production.cacheSeconds, 300)
    }

    func testStagingDiffersFromBothNeighbours() {
        // Staging exists to be production-like while still debuggable, so it
        // is the one profile whose values must not equal either neighbour's.
        let staging = AppEnvironment.staging

        XCTAssertNotEqual(staging.apiBaseURL, AppEnvironment.production.apiBaseURL)
        XCTAssertNotEqual(staging.apiBaseURL, AppEnvironment.development.apiBaseURL)
        XCTAssertTrue(staging.verboseErrors)
        XCTAssertEqual(staging.cacheSeconds, 30)
    }

    func testTheActiveProfileIsOneOfTheThree() {
        // The compile-time selection cannot silently fall through: AppConfig
        // raises #error when no condition is set. This only confirms the
        // chosen branch produced a real case.
        XCTAssertTrue(AppEnvironment.allCases.contains(AppConfig.current))
    }
}
