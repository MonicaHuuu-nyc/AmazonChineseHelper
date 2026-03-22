import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var actionLabel: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.title2)
                .foregroundStyle(AppColors.textPrimary)

            Spacer()

            if let label = actionLabel, let action {
                Button(action: action) {
                    Text(label)
                        .font(AppTypography.subheadline)
                        .foregroundStyle(AppColors.primaryBlue)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SectionHeaderView(title: "常买商品")
        SectionHeaderView(title: "为你推荐", actionLabel: "查看全部") { }
    }
    .padding()
}
