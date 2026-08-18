import Foundation

/// The three environment profiles this app ships (ADR-0018).
///
/// All three are plain data, so every one of them can be read and asserted in
/// a test — not just whichever happens to be compiled. Which one is *active*
/// is decided by the build configuration; see `AppConfig`.
enum AppEnvironment: String, CaseIterable {
    case development
    case staging
    case production

    var apiBaseURL: URL {
        switch self {
        case .development: URL(string: "http://localhost:8080")!
        case .staging: URL(string: "https://staging.example.com")!
        case .production: URL(string: "https://api.example.com")!
        }
    }

    /// Whether responses may carry detail useful only while developing.
    var verboseErrors: Bool {
        switch self {
        case .development, .staging: true
        case .production: false
        }
    }

    /// Seconds a successful response may be cached.
    var cacheSeconds: Int {
        switch self {
        case .development: 0
        case .staging: 30
        case .production: 300
        }
    }
}
