import SwiftUI
// tpl:if swiftdata
import SwiftData
// tpl:endif

@main
struct TemplateAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // tpl:if swiftdata
        .modelContainer(for: Item.self)
        // tpl:endif
    }
}
