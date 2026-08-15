import SwiftUI

struct HomeView: View {
    private let welcome = Welcome(now: .now)

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 44))
                    .foregroundStyle(.tint)
                Text(welcome.message(for: "TemplateApp"))
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text("Edit Views/HomeView.swift to make it yours.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("TemplateApp")
        }
    }
}

#Preview {
    HomeView()
}
