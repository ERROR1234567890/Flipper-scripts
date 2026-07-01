import Foundation

/// Mirrors the response shape of `https://api.dictionaryapi.dev/api/v2/entries/{lang}/{word}`.
/// The live API is inconsistent about which fields are present on any given
/// entry, so every field beyond `word` and the definition text itself is
/// optional -- a missing `phonetic` or `example` must never fail decoding of
/// the whole payload.
struct DictionaryEntry: Decodable {
    let word: String
    let phonetic: String?
    let meanings: [Meaning]
}

struct Meaning: Decodable {
    let partOfSpeech: String
    let definitions: [DefinitionDetail]
}

struct DefinitionDetail: Decodable {
    let definition: String
    let example: String?
}

/// Three explicit UI-facing states so a failed/absent network call always
/// renders a friendly message instead of a blank or broken sheet.
enum DefinitionResult {
    case success([DictionaryEntry])
    case notFound
    case networkError
}
