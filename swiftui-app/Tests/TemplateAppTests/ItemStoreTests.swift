import SwiftData
import XCTest
@testable import TemplateApp

/// SwiftData in memory: a real container and a real context, with nothing
/// written to disk — which is why these run in milliseconds and still test
/// the model rather than a mock of it.
final class ItemStoreTests: XCTestCase {
    private var container: ModelContainer!

    override func setUpWithError() throws {
        container = try ModelContainer(
            for: Item.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    override func tearDown() {
        container = nil
    }

    @MainActor
    func testInsertingAnItemMakesItFetchable() throws {
        let context = container.mainContext
        context.insert(Item(title: "Write the template"))

        let items = try context.fetch(FetchDescriptor<Item>())
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.title, "Write the template")
    }

    @MainActor
    func testItemsSortNewestFirst() throws {
        let context = container.mainContext
        let old = Date(timeIntervalSince1970: 1_000)
        context.insert(Item(title: "older", createdAt: old))
        context.insert(Item(title: "newer", createdAt: old.addingTimeInterval(60)))

        let descriptor = FetchDescriptor<Item>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        let titles = try context.fetch(descriptor).map(\.title)
        XCTAssertEqual(titles, ["newer", "older"])
    }

    @MainActor
    func testDeletingRemovesIt() throws {
        let context = container.mainContext
        let item = Item(title: "temporary")
        context.insert(item)
        context.delete(item)

        XCTAssertTrue(try context.fetch(FetchDescriptor<Item>()).isEmpty)
    }
}
