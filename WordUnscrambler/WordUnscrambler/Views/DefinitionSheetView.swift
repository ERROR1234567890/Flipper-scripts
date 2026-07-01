import SwiftUI

struct DefinitionSheetView: View {
    let word: String
    let language: DictionaryLanguage

    @Environment(\.dismiss) private var dismiss
    @State private var result: DefinitionResult?
    private let service = DefinitionService()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(word)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(String(localized: "action.done", defaultValue: "Done")) { dismiss() }
                    }
                }
                .task {
                    result = await service.fetchDefinition(word: word, language: language)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch result {
        case nil:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .notFound:
            ContentUnavailableView(
                String(localized: "definition.notFound", defaultValue: "No definition found"),
                systemImage: "questionmark.circle",
                description: Text(String(localized: "definition.notFoundDescription", defaultValue: "No dictionary entry exists for '\(word)'."))
            )
        case .networkError:
            ContentUnavailableView(
                String(localized: "definition.networkError", defaultValue: "Couldn't load definition"),
                systemImage: "wifi.slash",
                description: Text(String(localized: "definition.networkErrorDescription", defaultValue: "Check your connection and try again."))
            )
        case .success(let entries):
            List(Array(entries.enumerated()), id: \.offset) { _, entry in
                ForEach(Array(entry.meanings.enumerated()), id: \.offset) { _, meaning in
                    Section(meaning.partOfSpeech) {
                        ForEach(Array(meaning.definitions.enumerated()), id: \.offset) { _, detail in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(detail.definition)
                                if let example = detail.example {
                                    Text("\"\(example)\"")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DefinitionSheetView(word: "cat", language: .english)
}
