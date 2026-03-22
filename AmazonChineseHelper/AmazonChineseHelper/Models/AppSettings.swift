import Foundation

struct AppSettings {
    var isLargeTextMode: Bool
    var preferredCurrency: CurrencyUnit

    static let defaultSettings = AppSettings(
        isLargeTextMode: false,
        preferredCurrency: .usd
    )
}
