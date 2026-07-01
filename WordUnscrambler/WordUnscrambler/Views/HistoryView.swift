import SwiftUI

struct HistoryView: View {
    let onSelect: (String) -> Void

    @Environment(HistoryStore.self) private var historyStore

    var body: some View {
        NavigationStack {
            Group {
                if historyStore.entries.isEmpty {
                    ContentUnavailableView(
                        String(localized: "history.empty", defaultValue: "No history yet"),
                        systemImage: "clock"
                    )
                } else {
                    List {
                        ForEach(historyStore.entries) { entry in
                            Button {
                                onSelect(entry.rackInput)
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(entry.rackInput)
                                            .font(.headline)
                                        Spacer()
                                        Text(entry.language.displayName)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Text(entry.date, style: .relative)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    + Text(" · \(entry.resultCount) \(String(localized: "history.results", defaultValue: "results"))")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete { offsets in
                            offsets.map { historyStore.entries[$0] }.forEach(historyStore.remove)
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "tab.history", defaultValue: "History"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(String(localized: "history.clearAll", defaultValue: "Clear All"), role: .destructive) {
                        historyStore.clear()
                    }
                    .disabled(historyStore.entries.isEmpty)
                }
            }
        }
    }
}

#Preview {
    HistoryView(onSelect: { _ in })
        .environment(HistoryStore())
}
