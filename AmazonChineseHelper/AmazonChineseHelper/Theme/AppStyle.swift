import SwiftUI

enum AppStyle {
    static let cardRadius: CGFloat = 16
    static let chipRadius: CGFloat = 20
    static let buttonRadius: CGFloat = 12
    static let imageRadius: CGFloat = 12
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: AppStyle.cardRadius))
            .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }
}

struct ChipModifier: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .foregroundStyle(isSelected ? .white : AppColors.textSecondary)
            .background(isSelected ? AppColors.primaryBlue : AppColors.backgroundCard)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(
                        isSelected ? Color.clear : Color.gray.opacity(0.25),
                        lineWidth: 1
                    )
            )
    }
}

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(AppColors.primaryBlue)
            .clipShape(RoundedRectangle(cornerRadius: AppStyle.buttonRadius))
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }

    func chipStyle(isSelected: Bool) -> some View {
        modifier(ChipModifier(isSelected: isSelected))
    }

    func primaryButtonStyle() -> some View {
        modifier(PrimaryButtonModifier())
    }
}
