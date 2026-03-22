import SwiftUI

struct WarningCardView: View {
    var title: String = "重要说明"
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(AppColors.warning)
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.textPrimary)
            }

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: AppSpacing.sm) {
                        Text("•")
                            .foregroundStyle(AppColors.warning)
                        Text(item)
                            .font(AppTypography.subheadline)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
            }
        }
        .padding(AppSpacing.cardPadding)
        .background(AppColors.warningBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppStyle.cardRadius))
    }
}

#Preview {
    WarningCardView(items: [
        "需要转换插头 (国内插座适用)",
        "全球保修 (这不同 国内直接送修)",
        "包装不含 Apple Pencil",
    ])
    .padding()
}
