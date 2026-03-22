import SwiftUI

struct PriceView: View {
    let price: Double
    let currency: CurrencyUnit
    var originalPrice: Double? = nil
    var convertedPrice: Double? = nil
    var preferredCurrency: CurrencyUnit = .usd
    var showConverted: Bool = false
    var size: PriceSize = .medium

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.sm) {
            Text(displayPrice)
                .font(size.font)
                .foregroundStyle(AppColors.priceColor)

            if let original = originalPrice {
                Text(CurrencyFormatter.format(price: original, currency: displayCurrency))
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

    private var displayCurrency: CurrencyUnit {
        preferredCurrency
    }

    private var displayPrice: String {
        if preferredCurrency == currency {
            return CurrencyFormatter.format(price: price, currency: currency)
        } else if let converted = convertedPrice {
            return CurrencyFormatter.format(price: converted, currency: preferredCurrency)
        } else {
            let converted = CurrencyFormatter.convert(price: price, from: currency, to: preferredCurrency)
            return CurrencyFormatter.format(price: converted, currency: preferredCurrency)
        }
    }

    private var convertedText: String {
        if preferredCurrency == currency, let converted = convertedPrice {
            return "约 \(CurrencyFormatter.format(price: converted, currency: preferredCurrency == .usd ? .cny : .usd))"
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
        PriceView(price: 149.95, currency: .usd, preferredCurrency: .cny, size: .medium)
    }
    .padding()
}
