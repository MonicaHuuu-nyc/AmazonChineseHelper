import SwiftUI

// MARK: - Preview-Only Model (temporary, replaced in Phase 2)

private struct PreviewProduct: Identifiable {
    let id = UUID()
    let title: String
    let chineseTitle: String
    let price: Double
    let systemImage: String
}

private let previewProducts: [PreviewProduct] = [
    PreviewProduct(
        title: "Philips Sonicare Electric Toothbrush HX9911",
        chineseTitle: "飞利浦声波电动牙刷 HX9911",
        price: 149.95,
        systemImage: "mouth"
    ),
    PreviewProduct(
        title: "Apple iPad Pro 11-inch M2, 128GB",
        chineseTitle: "iPad Pro 11英寸 M2 芯片, 128GB",
        price: 799.00,
        systemImage: "ipad"
    ),
    PreviewProduct(
        title: "Noise Cancelling Wireless Headphones",
        chineseTitle: "降噪无线耳机 - 皮质白",
        price: 199.00,
        systemImage: "headphones"
    ),
    PreviewProduct(
        title: "Smart Electric Kettle, 1.7L Stainless Steel",
        chineseTitle: "智能恒温电水壶 1.7升不锈钢",
        price: 45.50,
        systemImage: "cup.and.saucer"
    ),
    PreviewProduct(
        title: "Nike Air Zoom Pegasus 39 Running Shoes",
        chineseTitle: "耐克 Air Zoom Pegasus 39 男士跑鞋",
        price: 119.99,
        systemImage: "shoe"
    ),
]

// MARK: - Product Row

private struct ProductRow: View {
    let product: PreviewProduct

    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            Image(systemName: product.systemImage)
                .font(.title)
                .frame(width: 64, height: 64)
                .foregroundStyle(AppColors.primaryBlue)
                .background(AppColors.primaryBlueLight)
                .clipShape(RoundedRectangle(cornerRadius: AppStyle.imageRadius))

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(product.chineseTitle)
                    .font(AppTypography.headline)

                Text(product.title)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(2)

                Text(CurrencyFormatter.format(price: product.price, currency: .usd))
                    .font(AppTypography.priceSmall)
                    .foregroundStyle(AppColors.priceColor)
            }
        }
        .padding(AppSpacing.cardPadding)
        .cardStyle()
    }
}

// MARK: - Home Screen

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                Text("\(GreetingHelper.currentGreeting())，找点什么？")
                    .font(AppTypography.largeTitle)
                    .foregroundStyle(AppColors.textPrimary)
                    .padding(.top, AppSpacing.sm)

                ForEach(previewProducts) { product in
                    ProductRow(product: product)
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.backgroundSecondary)
        .navigationTitle("亚马逊中文购物助手")
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environment(SettingsStore())
            .environment(FavoritesStore(service: LocalFavoritesService()))
    }
}
