import SwiftUI

struct FavoritesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                Text("我的收藏")
                    .font(AppTypography.largeTitle)

                Text("为您精心挑选的愿望清单")
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.textSecondary)

                Text("收藏功能将在 Phase 6 实现")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textTertiary)
                    .padding(.top, AppSpacing.xxl)
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.top, AppSpacing.lg)
        }
        .background(AppColors.backgroundSecondary)
        .navigationTitle("亚马逊中文购物助手")
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
