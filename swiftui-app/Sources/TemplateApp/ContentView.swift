import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            // tpl:if swiftdata
            ItemsView()
                .tabItem { Label("Items", systemImage: "tray.full") }
            // tpl:endif
            // tpl:if networking
            GreetingView()
                .tabItem { Label("Greeting", systemImage: "globe") }
            // tpl:endif
        }
    }
}

#Preview {
    ContentView()
}
