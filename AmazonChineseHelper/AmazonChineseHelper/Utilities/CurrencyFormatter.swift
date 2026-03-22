import Foundation

enum CurrencyFormatter {

    private static let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    static func format(price: Double, currency: CurrencyUnit) -> String {
        let formatted = numberFormatter.string(from: NSNumber(value: price)) ?? String(format: "%.2f", price)
        return "\(currency.symbol)\(formatted)"
    }

    static func convert(price: Double, from source: CurrencyUnit, to target: CurrencyUnit) -> Double {
        guard source != target else { return price }
        switch (source, target) {
        case (.usd, .cny): return price * CurrencyUnit.exchangeRate
        case (.cny, .usd): return price / CurrencyUnit.exchangeRate
        default: return price
        }
    }

    static func convertedPriceString(price: Double, from source: CurrencyUnit, to target: CurrencyUnit) -> String {
        let converted = convert(price: price, from: source, to: target)
        return "约 \(format(price: converted, currency: target))"
    }
}
