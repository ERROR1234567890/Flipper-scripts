import SwiftUI

struct UnscrambleView: View {
    @Binding var pendingRackInput: String?

    @Environment(SettingsStore.self) private var settingsStore
    @Environment(HistoryStore.self) private var historyStore
    @Environment(FavoritesStore.self) private var favoritesStore
    @Environment(WordListService.self) private var wordListService

    @State private var rackInput = ""
    @State private var results: [ScoredWord] = []
    @State private var isSolving = false
    @State private var activeFilter = WordFilter()
    @State private var sortOption: ScoredWord.SortOption = .scoreDescending
    @State private var showFilterSheet = false
    @State private var showCamera = false
    @State private var selectedWord: ScoredWord?

    private var filteredResults: [ScoredWord] {
        ScoredWord.sorted(activeFilter.apply(to: results), by: sortOption)
    }

    private var shareText: String {
        let words = filteredResults.map(\.word).joined(separator: ", ")
        return String(localized: "share.format", defaultValue: "Words found: \(words)")
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                inputRow

                HStack {
                    Button {
                        showFilterSheet = true
                    } label: {
                        Label(String(localized: "action.filter", defaultValue: "Filter"), systemImage: "line.3.horizontal.decrease.circle")
                    }

                    Spacer()

                    Picker(String(localized: "action.sort", defaultValue: "Sort"), selection: $sortOption) {
                        Text(String(localized: "sort.score", defaultValue: "Score")).tag(ScoredWord.SortOption.scoreDescending)
                        Text(String(localized: "sort.alphabetical", defaultValue: "A-Z")).tag(ScoredWord.SortOption.alphabetical)
                        Text(String(localized: "sort.length", defaultValue: "Length")).tag(ScoredWord.SortOption.lengthDescending)
                    }
                    .pickerStyle(.menu)

                    Spacer()

                    ShareLink(item: shareText) {
                        Label(String(localized: "action.share", defaultValue: "Share"), systemImage: "square.and.arrow.up")
                    }
                    .disabled(filteredResults.isEmpty)
                }
                .padding(.horizontal)

                if isSolving {
                    ProgressView()
                        .padding(.top, 24)
                    Spacer()
                } else {
                    ResultsListView(
                        results: filteredResults,
                        favoritesStore: favoritesStore,
                        onSelect: { selectedWord = $0 }
                    )
                }
            }
            .navigationTitle(String(localized: "app.title", defaultValue: "Word Unscrambler"))
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(filter: $activeFilter)
            }
            .sheet(item: $selectedWord) { word in
                DefinitionSheetView(word: word.word, language: settingsStore.dictionaryLanguage)
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraCaptureView(language: settingsStore.dictionaryLanguage) { recognizedText in
                    if !recognizedText.isEmpty {
                        rackInput = recognizedText
                        solve()
                    }
                    showCamera = false
                }
            }
            .onChange(of: pendingRackInput) { _, newValue in
                guard let newValue else { return }
                rackInput = newValue
                pendingRackInput = nil
                solve()
            }
        }
    }

    private var inputRow: some View {
        HStack {
            TextField(
                String(localized: "input.placeholder", defaultValue: "Enter letters, ? for blank"),
                text: $rackInput
            )
            .textFieldStyle(.roundedBorder)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onSubmit(solve)

            Button {
                showCamera = true
            } label: {
                Image(systemName: "camera")
            }
            .accessibilityLabel(String(localized: "action.camera", defaultValue: "Scan letters with camera"))

            Button(String(localized: "action.solve", defaultValue: "Solve"), action: solve)
                .buttonStyle(.borderedProminent)
                .disabled(rackInput.isEmpty)
        }
        .padding(.horizontal)
        .padding(.top)
    }

    private func solve() {
        let language = settingsStore.dictionaryLanguage
        let input = rackInput
        isSolving = true
        Task {
            let trie = await wordListService.trie(for: language)
            let rack = LetterRack(rawInput: input)
            let solver = AnagramSolver(trie: trie, scoreTable: LetterScoreTable.table(for: language))
            let found = await Task.detached(priority: .userInitiated) {
                solver.solve(rack: rack)
            }.value
            results = found
            historyStore.record(rackInput: input, language: language, resultCount: found.count)
            isSolving = false
        }
    }
}

#Preview {
    UnscrambleView(pendingRackInput: .constant(nil))
        .environment(SettingsStore())
        .environment(HistoryStore())
        .environment(FavoritesStore())
        .environment(WordListService())
}
