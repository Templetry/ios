import SwiftData
import SwiftUI

struct ItemsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Item.createdAt, order: .reverse) private var items: [Item]
    @State private var draft = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("New item", text: $draft)
                            .onSubmit(add)
                        Button("Add", action: add)
                            .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                        Text(item.createdAt, format: .dateTime)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Items")
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView("No items yet", systemImage: "tray")
                }
            }
        }
    }

    private func add() {
        let title = draft.trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty else { return }
        context.insert(Item(title: title))
        draft = ""
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(items[index])
        }
    }
}

#Preview {
    ItemsView()
        .modelContainer(for: Item.self, inMemory: true)
}
