import Foundation
import SwiftData

/// A stored item.
///
/// `@Model` makes this a persisted class, so it is a reference type with
/// change tracking — not a value type. Keep behaviour that does not need
/// persistence out of it.
@Model
final class Item {
    var title: String
    var createdAt: Date

    init(title: String, createdAt: Date = .now) {
        self.title = title
        self.createdAt = createdAt
    }
}
