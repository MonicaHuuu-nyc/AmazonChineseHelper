import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                Text("\(GreetingHelper.currentGreeting())，找点什么？")
                    .font(AppTypography.largeTitle)
                    .foregroundStyle(AppColors.textPrimary)
                    .padding(.top, AppSpacing.sm)

                Text("首页内容将在 Phase 3 实现")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textTertiary)
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
        }
        .background(AppColors.backgroundSecondary)
        .navigationTitle("亚马逊中文购物助手")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
