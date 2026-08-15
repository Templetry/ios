import Foundation

/// What the greeting endpoint returns.
struct Greeting: Decodable, Equatable {
    let message: String
}

/// The screen's state, testable because it takes its client rather than
/// building one. `@Observable` means SwiftUI tracks the properties a view
/// actually reads, so there is nothing to publish by hand.
@MainActor
@Observable
final class GreetingViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded(String)
        case failed(String)
    }

    private(set) var state: State = .idle
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func load(name: String) async {
        state = .loading
        do {
            let greeting = try await client.get("api/hello/\(name)", as: Greeting.self)
            state = .loaded(greeting.message)
        } catch {
            // The message is for a person, so it says what failed rather
            // than dumping the error's description.
            state = .failed("Could not reach the service.")
        }
    }
}
