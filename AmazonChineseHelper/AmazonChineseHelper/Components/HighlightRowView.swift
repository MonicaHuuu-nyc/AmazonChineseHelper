import SwiftUI

struct HighlightRowView: View {
    let highlight: ProductHighlight

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: highlight.iconName)
                .font(.title3)
                .foregroundStyle(AppColors.primaryBlue)
                .frame(width: 40, height: 40)
                .background(AppColors.primaryBlueLight)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(highlight.title)
                    .font(AppTypography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)

                Text(highlight.subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.md)
    }
}

#Preview {
    VStack(spacing: 0) {
        HighlightRowView(highlight: ProductHighlight(
            id: "h1", iconName: "cpu", title: "M2 芯片", subtitle: "性能提升 15%，图形处理快 35%"
        ))
        Divider().padding(.leading, 68)
        HighlightRowView(highlight: ProductHighlight(
            id: "h2", iconName: "video.fill", title: "ProRes 视频录制", subtitle: "首次支持专业视频编辑的 iPad"
        ))
        Divider().padding(.leading, 68)
        HighlightRowView(highlight: ProductHighlight(
            id: "h3", iconName: "pencil.tip", title: "Apple Pencil 悬停", subtitle: "精准书写交互式体验"
        ))
    }
    .cardStyle()
    .padding()
}
