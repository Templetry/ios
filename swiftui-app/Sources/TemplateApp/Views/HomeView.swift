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
                // tpl:if environments
                // Hidden in production — a badge that is always visible stops
                // being information.
                if AppConfig.current != .production {
                    Text(AppConfig.current.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.quaternary, in: Capsule())
                }
                // tpl:endif
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
