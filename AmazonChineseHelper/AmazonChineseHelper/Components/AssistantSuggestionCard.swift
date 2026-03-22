import SwiftUI

struct AssistantSuggestionCard: View {
    let suggestion: AssistantSuggestion
    var onAction: (AssistantAction) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "sparkle")
                    .foregroundStyle(AppColors.primaryBlue)
                Text("购物助手建议")
                    .font(AppTypography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)
            }

            Text(suggestion.message)
                .font(AppTypography.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .lineSpacing(4)

            HStack(spacing: AppSpacing.sm) {
                ForEach(suggestion.actions) { action in
                    Button {
                        onAction(action)
                    } label: {
                        Text(action.label)
                            .font(AppTypography.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(AppColors.primaryBlue)
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, AppSpacing.sm)
                            .background(AppColors.primaryBlueLight)
                            .clipShape(RoundedRectangle(cornerRadius: AppStyle.buttonRadius))
                    }
                }
            }
        }
        .padding(AppSpacing.cardPadding)
        .background(
            LinearGradient(
                colors: [AppColors.backgroundSecondary, AppColors.primaryBlue.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppStyle.cardRadius))
    }
}

#Preview {
    AssistantSuggestionCard(
        suggestion: AssistantSuggestion(
            message: "正在为您搜索关于 \"电动牙刷\" 的评论摘要。大多数用户表示在亚马逊购买飞利浦品牌更具价格优势，但请注意查看插头电压是否适配您的地区。",
            actions: [
                AssistantAction(id: "a1", label: "查看评论翻译", type: .reviewTranslation),
                AssistantAction(id: "a2", label: "比较历史价格", type: .priceHistory),
            ]
        )
    )
    .padding()
}
