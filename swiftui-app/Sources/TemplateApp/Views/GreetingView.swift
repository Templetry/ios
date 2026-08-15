import SwiftUI

struct GreetingView: View {
    @State private var model = GreetingViewModel(
        client: HTTPAPIClient(baseURL: URL(string: "https://example.com")!)
    )
    @State private var name = "World"

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    Button("Load greeting") {
                        Task { await model.load(name: name) }
                    }
                }
                Section {
                    switch model.state {
                    case .idle:
                        Text("Nothing loaded yet.").foregroundStyle(.secondary)
                    case .loading:
                        ProgressView()
                    case .loaded(let message):
                        Text(message)
                    case .failed(let reason):
                        Text(reason).foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Greeting")
        }
    }
}

#Preview {
    GreetingView()
}
