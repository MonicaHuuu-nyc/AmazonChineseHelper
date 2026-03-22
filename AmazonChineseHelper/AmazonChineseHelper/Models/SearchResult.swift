import Foundation

struct SearchResult {
    let products: [Product]
    let totalCount: Int
    let suggestion: AssistantSuggestion?
}
