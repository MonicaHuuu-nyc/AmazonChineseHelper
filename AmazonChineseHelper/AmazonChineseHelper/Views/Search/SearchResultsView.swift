import SwiftUI

struct SearchResultsView: View {
    let initialQuery: String

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Text("搜索: \(initialQuery)")
                .font(AppTypography.title)

            Text("搜索结果将在 Phase 4 实现")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.backgroundSecondary)
        .navigationTitle("搜索结果")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SearchResultsView(initialQuery: "电动牙刷")
    }
}
