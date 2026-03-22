import SwiftUI

@Observable
final class SettingsStore {

    var isLargeTextMode: Bool {
        didSet { UserDefaults.standard.set(isLargeTextMode, forKey: "isLargeTextMode") }
    }

    var preferredCurrency: CurrencyUnit {
        didSet { UserDefaults.standard.set(preferredCurrency.rawValue, forKey: "preferredCurrency") }
    }

    init() {
        self.isLargeTextMode = UserDefaults.standard.bool(forKey: "isLargeTextMode")
        let raw = UserDefaults.standard.string(forKey: "preferredCurrency") ?? CurrencyUnit.usd.rawValue
        self.preferredCurrency = CurrencyUnit(rawValue: raw) ?? .usd
    }
}
