import SwiftUI

struct FilterSheetView: View {
    @Binding var filter: WordFilter
    @Environment(\.dismiss) private var dismiss

    @State private var draft: WordFilter

    init(filter: Binding<WordFilter>) {
        self._filter = filter
        self._draft = State(initialValue: filter.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(String(localized: "filter.length", defaultValue: "Length")) {
                    optionalIntField(String(localized: "filter.exactLength", defaultValue: "Exact length"), value: $draft.exactLength)
                    optionalIntField(String(localized: "filter.minLength", defaultValue: "Minimum length"), value: $draft.minLength)
                    optionalIntField(String(localized: "filter.maxLength", defaultValue: "Maximum length"), value: $draft.maxLength)
                }

                Section(String(localized: "filter.text", defaultValue: "Text")) {
                    TextField(String(localized: "filter.startsWith", defaultValue: "Starts with"), text: $draft.startsWith)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    TextField(String(localized: "filter.contains", defaultValue: "Contains"), text: $draft.contains)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                Section {
                    TextField("_a__e", text: $draft.pattern)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text(String(localized: "filter.pattern", defaultValue: "Pattern"))
                } footer: {
                    Text(String(localized: "filter.patternHelp", defaultValue: "Use _ for unknown letters, e.g. _a__e matches a 5-letter word with 'a' second and 'e' last."))
                }

                Section {
                    Button(String(localized: "filter.reset", defaultValue: "Reset filters"), role: .destructive) {
                        draft = WordFilter()
                    }
                }
            }
            .navigationTitle(String(localized: "filter.title", defaultValue: "Filters"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "action.apply", defaultValue: "Apply")) {
                        filter = draft
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "action.cancel", defaultValue: "Cancel"), role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }

    private func optionalIntField(_ title: String, value: Binding<Int?>) -> some View {
        TextField(title, text: Binding(
            get: { value.wrappedValue.map(String.init) ?? "" },
            set: { value.wrappedValue = Int($0) }
        ))
        .keyboardType(.numberPad)
    }
}

#Preview {
    FilterSheetView(filter: .constant(WordFilter()))
}
