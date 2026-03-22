import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                Text("设置")
                    .font(AppTypography.largeTitle)

                Text("个性化您的购物助手机器人")
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.textSecondary)

                Text("设置功能将在 Phase 6 实现")
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
        SettingsView()
    }
}
