import XCTest
@testable import TemplateApp

/// A client that answers from memory. This is what the `APIClient` protocol
/// buys: no URLProtocol stub, no local server, no network in the suite.
private struct StubClient: APIClient {
    var result: Result<Greeting, Error>

    func get<T: Decodable>(_ path: String, as type: T.Type) async throws -> T {
        switch result {
        case .success(let greeting):
            guard let value = greeting as? T else { throw APIError.invalidURL(path) }
            return value
        case .failure(let error):
            throw error
        }
    }
}

final class GreetingViewModelTests: XCTestCase {

    @MainActor
    func testStartsIdle() {
        let model = GreetingViewModel(client: StubClient(result: .success(Greeting(message: "hi"))))
        XCTAssertEqual(model.state, .idle)
    }

    @MainActor
    func testLoadsAGreeting() async {
        let model = GreetingViewModel(client: StubClient(result: .success(Greeting(message: "Hello, World!"))))

        await model.load(name: "World")

        XCTAssertEqual(model.state, .loaded("Hello, World!"))
    }

    @MainActor
    func testAFailureBecomesAReadableMessage() async {
        let model = GreetingViewModel(client: StubClient(result: .failure(APIError.badStatus(500))))

        await model.load(name: "World")

        // Not the error's description: the state a person reads.
        XCTAssertEqual(model.state, .failed("Could not reach the service."))
    }
}
