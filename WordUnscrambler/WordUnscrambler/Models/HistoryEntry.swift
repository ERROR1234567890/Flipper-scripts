import Foundation

struct HistoryEntry: Codable, Identifiable, Hashable {
    let id: UUID
    let rackInput: String
    let language: DictionaryLanguage
    let date: Date
    let resultCount: Int

    init(rackInput: String, language: DictionaryLanguage, resultCount: Int, date: Date = Date()) {
        self.id = UUID()
        self.rackInput = rackInput
        self.language = language
        self.resultCount = resultCount
        self.date = date
    }
}
