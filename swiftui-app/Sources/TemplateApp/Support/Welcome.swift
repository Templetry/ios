import Foundation

/// What the home screen greets with.
///
/// A plain value type with no SwiftUI in it, which is the point: the rule
/// lives here where a test can read it, not inside a `View` where it cannot.
struct Welcome {
    let now: Date
    var calendar: Calendar = .current

    var greeting: String {
        switch calendar.component(.hour, from: now) {
        case 5..<12: "Good morning"
        case 12..<18: "Good afternoon"
        case 18..<22: "Good evening"
        default: "Good night"
        }
    }

    func message(for appName: String) -> String {
        "\(greeting) — this is \(appName)."
    }
}
