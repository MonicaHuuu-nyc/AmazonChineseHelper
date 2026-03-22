import SwiftUI

enum AppColors {
    static let primaryBlue = Color(red: 0.145, green: 0.388, blue: 0.922)     // #2563EB
    static let primaryBlueLight = Color(red: 0.145, green: 0.388, blue: 0.922).opacity(0.08)

    static let textPrimary = Color(red: 0.07, green: 0.07, blue: 0.07)
    static let textSecondary = Color(red: 0.42, green: 0.42, blue: 0.45)
    static let textTertiary = Color(red: 0.68, green: 0.68, blue: 0.70)

    static let backgroundPrimary = Color.white
    static let backgroundSecondary = Color(red: 0.96, green: 0.96, blue: 0.97) // #F5F5F7
    static let backgroundCard = Color.white

    static let warning = Color(red: 0.90, green: 0.60, blue: 0.10)
    static let warningBackground = Color(red: 1.0, green: 0.95, blue: 0.88)
    static let destructive = Color(red: 0.86, green: 0.24, blue: 0.24)

    static let priceColor = primaryBlue
    static let ratingGold = Color(red: 0.98, green: 0.75, blue: 0.18)

    static func tagForeground(for style: TagStyle) -> Color {
        switch style {
        case .popular:   return Color(red: 0.17, green: 0.34, blue: 0.85)
        case .premium:   return Color(red: 0.55, green: 0.22, blue: 0.78)
        case .highTech:  return Color(red: 0.13, green: 0.55, blue: 0.55)
        case .value:     return Color(red: 0.16, green: 0.60, blue: 0.30)
        case .bundle:    return Color(red: 0.16, green: 0.60, blue: 0.30)
        case .kids:      return Color(red: 0.80, green: 0.40, blue: 0.15)
        case .basic:     return Color(red: 0.40, green: 0.40, blue: 0.45)
        }
    }

    static func tagBackground(for style: TagStyle) -> Color {
        tagForeground(for: style).opacity(0.10)
    }
}
