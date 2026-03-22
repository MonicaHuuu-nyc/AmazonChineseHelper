import SwiftUI

struct ProductDetailView: View {
    let productID: String

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Text("商品详情")
                .font(AppTypography.title)

            Text("商品 ID: \(productID)")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)

            Text("商品详情将在 Phase 5 实现")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.backgroundSecondary)
        .navigationTitle("商品详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(productID: "B0BSHF7WHT")
    }
}
