import Foundation

enum ActionType: String, Codable {
    case reviewTranslation
    case priceHistory
    case priceComparison
    case sizing
}

struct AssistantAction: Codable, Identifiable {
    let id: String
    let label: String
    let type: ActionType
}

struct AssistantSuggestion: Codable {
    let message: String
    let actions: [AssistantAction]
}
