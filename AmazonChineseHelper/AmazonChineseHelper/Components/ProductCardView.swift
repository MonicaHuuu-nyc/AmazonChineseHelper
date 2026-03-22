import SwiftUI

// MARK: - Compact Card (Home horizontal scroll)

struct ProductCardCompact: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            ProductImageView(
                imageName: product.imageNames.first ?? "photo",
                size: 120,
                cornerRadius: AppStyle.imageRadius
            )

            Text(product.title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(2)
                .frame(width: 120, alignment: .leading)

            Text(CurrencyFormatter.format(price: product.price, currency: product.currency))
                .font(AppTypography.priceSmall)
                .foregroundStyle(AppColors.priceColor)
        }
        .padding(AppSpacing.md)
        .cardStyle()
    }
}

// MARK: - Search Result Card

struct ProductCardSearch: View {
    let product: Product
    var isFavorite: Bool = false
    var onFavoriteToggle: () -> Void = {}

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            ProductImageView(
                imageName: product.imageNames.first ?? "photo",
                size: 100,
                cornerRadius: AppStyle.imageRadius
            )

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                HStack(alignment: .top) {
                    Text(product.title)
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(2)

                    Spacer()

                    Button(action: onFavoriteToggle) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? AppColors.destructive : AppColors.textTertiary)
                    }
                }

                PriceView(
                    price: product.price,
                    currency: product.currency,
                    originalPrice: product.originalPrice
                )

                Text(product.description)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(2)

                if !product.tags.isEmpty {
                    HStack(spacing: AppSpacing.xs) {
                        ForEach(product.tags) { tag in
                            TagView(tag: tag)
                        }
                    }
                }
            }
        }
        .padding(AppSpacing.cardPadding)
        .cardStyle()
    }
}

// MARK: - Favorite Card

struct ProductCardFavorite: View {
    let product: Product
    var onRemove: () -> Void = {}

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ProductImageView(
                imageName: product.imageNames.first ?? "photo",
                size: 90,
                cornerRadius: AppStyle.imageRadius
            )

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(product.title)
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(2)

                PriceView(
                    price: product.price,
                    currency: product.currency,
                    originalPrice: product.originalPrice
                )

                HStack {
                    Text("来自\(product.source)")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textTertiary)

                    Spacer()

                    if product.isOnSale {
                        Text("降价中")
                            .font(AppTypography.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, AppSpacing.sm)
                            .padding(.vertical, 2)
                            .foregroundStyle(AppColors.warning)
                            .background(AppColors.warningBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }

                HStack {
                    Spacer()
                    Button(action: onRemove) {
                        HStack(spacing: AppSpacing.xs) {
                            Image(systemName: "trash")
                            Text("移除")
                        }
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.destructive)
                    }
                }
            }
        }
        .padding(AppSpacing.cardPadding)
        .cardStyle()
    }
}

// MARK: - Recommendation Card (Home vertical list)

struct ProductCardRecommendation: View {
    let product: Product

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ProductImageView(
                imageName: product.imageNames.first ?? "photo",
                size: 90,
                cornerRadius: AppStyle.imageRadius
            )

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(product.title)
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(2)

                Text(product.originalTitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textTertiary)
                    .lineLimit(1)

                PriceView(
                    price: product.price,
                    currency: product.currency
                )
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.cardPadding)
        .cardStyle()
    }
}

// MARK: - Previews

private let sampleProduct = Product(
    id: "B09LM4FGQ1",
    title: "飞利浦声波电动牙刷 HX9911",
    originalTitle: "Philips Sonicare DiamondClean Smart Electric Toothbrush HX9911",
    price: 149.95,
    currency: .usd,
    convertedPrice: 1065.00,
    originalPrice: nil,
    rating: 4.7,
    reviewCount: 15632,
    imageNames: ["mouth"],
    description: "适合敏感牙龈，深度清洁。附带旅行盒与智能压力传感器。",
    highlights: [],
    warnings: [],
    tags: [ProductTag(label: "人气之选", style: .popular), ProductTag(label: "基础用", style: .basic)],
    source: "Philips 官方店",
    amazonURL: "https://www.amazon.com/dp/B09LM4FGQ1",
    categoryId: "beauty",
    isBadged: false,
    isOnSale: false
)

private let saleProduct = Product(
    id: "B09NKGM7GX",
    title: "现代简约不锈钢石英腕表 - 蓝宝石镜面防水设计",
    originalTitle: "Modern Minimalist Stainless Steel Quartz Watch",
    price: 175.00,
    currency: .usd,
    convertedPrice: 1243.00,
    originalPrice: 250.00,
    rating: 4.4,
    reviewCount: 2156,
    imageNames: ["applewatch"],
    description: "日本进口石英机芯，蓝宝石水晶镜面耐刮耐磨。",
    highlights: [],
    warnings: [],
    tags: [ProductTag(label: "性价比高", style: .value)],
    source: "亚马逊淘外购",
    amazonURL: "https://www.amazon.com/dp/B09NKGM7GX",
    categoryId: "hot",
    isBadged: false,
    isOnSale: true
)

#Preview("Compact") {
    ProductCardCompact(product: sampleProduct)
        .padding()
}

#Preview("Search Result") {
    ProductCardSearch(product: sampleProduct, isFavorite: true)
        .padding()
}

#Preview("Favorite") {
    ProductCardFavorite(product: saleProduct)
        .padding()
}

#Preview("Recommendation") {
    ProductCardRecommendation(product: sampleProduct)
        .padding()
}
