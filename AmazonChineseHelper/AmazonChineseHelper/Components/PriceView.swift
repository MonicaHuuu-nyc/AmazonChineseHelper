import SwiftUI

struct PriceView: View {
    let price: Double
    let currency: CurrencyUnit
    var originalPrice: Double? = nil
    var convertedPrice: Double? = nil
    var showConverted: Bool = false
    var size: PriceSize = .medium

    @Environment(SettingsStore.self) private var settingsStore

    private var preferred: CurrencyUnit { settingsStore.preferredCurrency }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.sm) {
            Text(displayPrice)
                .font(size.font)
                .foregroundStyle(AppColors.priceColor)

            if let original = originalPrice {
                Text(formattedOriginal(original))
                    .font(size.strikethroughFont)
                    .foregroundStyle(AppColors.textTertiary)
                    .strikethrough()
            }

            if showConverted {
                Text(convertedText)
                    .font(size.secondaryFont)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    private var displayPrice: String {
        if preferred == currency {
            return CurrencyFormatter.format(price: price, currency: currency)
        } else if let converted = convertedPrice {
            return CurrencyFormatter.format(price: converted, currency: preferred)
        } else {
            let converted = CurrencyFormatter.convert(price: price, from: currency, to: preferred)
            return CurrencyFormatter.format(price: converted, currency: preferred)
        }
    }

    private func formattedOriginal(_ original: Double) -> String {
        if preferred == currency {
            return CurrencyFormatter.format(price: original, currency: currency)
        } else {
            let converted = CurrencyFormatter.convert(price: original, from: currency, to: preferred)
            return CurrencyFormatter.format(price: converted, currency: preferred)
        }
    }

    private var convertedText: String {
        let otherCurrency: CurrencyUnit = preferred == .usd ? .cny : .usd
        if preferred == currency {
            if let converted = convertedPrice {
                return "约 \(CurrencyFormatter.format(price: converted, currency: otherCurrency))"
            }
            let converted = CurrencyFormatter.convert(price: price, from: currency, to: otherCurrency)
            return "约 \(CurrencyFormatter.format(price: converted, currency: otherCurrency))"
        }
        return "约 \(CurrencyFormatter.format(price: price, currency: currency))"
    }
}

enum PriceSize {
    case small, medium, large

    var font: Font {
        switch self {
        case .small:  return AppTypography.priceSmall
        case .medium: return AppTypography.priceSmall
        case .large:  return AppTypography.price
        }
    }

    var strikethroughFont: Font {
        switch self {
        case .small:  return AppTypography.caption
        case .medium: return AppTypography.subheadline
        case .large:  return AppTypography.body
        }
    }

    var secondaryFont: Font {
        switch self {
        case .small:  return AppTypography.caption
        case .medium: return AppTypography.caption
        case .large:  return AppTypography.subheadline
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        PriceView(price: 799.00, currency: .usd, size: .large)
        PriceView(price: 799.00, currency: .usd, originalPrice: 999.00, size: .medium)
        PriceView(price: 799.00, currency: .usd, convertedPrice: 5673.00, showConverted: true, size: .large)
    }
    .padding()
    .environment(SettingsStore())
}
