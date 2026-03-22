import SwiftUI

enum AppTypography {
    static let largeTitle: Font = .largeTitle.bold()
    static let title: Font = .title.bold()
    static let title2: Font = .title2.bold()
    static let headline: Font = .headline
    static let subheadline: Font = .subheadline
    static let body: Font = .body
    static let caption: Font = .caption
    static let caption2: Font = .caption2
    static let price: Font = .title2.bold().monospacedDigit()
    static let priceSmall: Font = .headline.bold().monospacedDigit()
}
