import Foundation

enum CurrencyUnit: String, Codable, CaseIterable {
    case usd
    case cny

    var symbol: String {
        switch self {
        case .usd: return "$"
        case .cny: return "¥"
        }
    }

    var code: String {
        switch self {
        case .usd: return "USD"
        case .cny: return "CNY"
        }
    }

    var displayName: String {
        switch self {
        case .usd: return "USD ($)"
        case .cny: return "CNY (¥)"
        }
    }

    /// Hardcoded exchange rate for MVP (CNY per 1 USD)
    static let exchangeRate: Double = 7.1
}
