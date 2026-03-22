import SwiftUI

struct ProductDetailView: View {
    let productID: String

    @State private var viewModel: ProductDetailViewModel
    @State private var currentImageIndex = 0
    @Environment(FavoritesStore.self) private var favoritesStore
    @Environment(SettingsStore.self) private var settingsStore

    init(productID: String) {
        self.productID = productID
        self._viewModel = State(initialValue: ProductDetailViewModel(productID: productID))
    }

    var body: some View {
        Group {
            if let product = viewModel.product {
                productContent(product)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ProgressView("加载中...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(AppColors.backgroundSecondary)
        .navigationTitle("亚马逊中文购物助手")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let product = viewModel.product {
                    Button {
                        favoritesStore.toggle(productID: product.id)
                    } label: {
                        Image(systemName: favoritesStore.isFavorite(productID: product.id) ? "heart.fill" : "heart")
                            .foregroundStyle(favoritesStore.isFavorite(productID: product.id) ? AppColors.destructive : AppColors.textSecondary)
                    }
                }
            }
        }
        .task {
            await viewModel.loadProduct()
        }
    }

    // MARK: - Main Content

    private func productContent(_ product: Product) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    imageGallery(product)
                    productInfo(product)
                    warningsSection(product)
                    descriptionSection(product)
                    highlightsSection(product)
                    assistantSection
                }
                .padding(.bottom, AppSpacing.xxxl)
            }

            ctaButton(product)
        }
    }

    // MARK: - Image Gallery

    private func imageGallery(_ product: Product) -> some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $currentImageIndex) {
                ForEach(Array(product.imageNames.enumerated()), id: \.offset) { index, name in
                    Image(systemName: name)
                        .font(.system(size: 64))
                        .foregroundStyle(AppColors.primaryBlue)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(AppColors.backgroundCard)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)

            Text("\(currentImageIndex + 1)/\(product.imageNames.count)")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xs)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(AppSpacing.md)
        }
    }

    // MARK: - Product Info

    private func productInfo(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            badgesRow(product)

            Text(product.title)
                .font(AppTypography.title2)
                .foregroundStyle(AppColors.textPrimary)

            priceRow(product)

            RatingView(rating: product.rating, reviewCount: product.reviewCount)
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
    }

    private func badgesRow(_ product: Product) -> some View {
        HStack(spacing: AppSpacing.sm) {
            if product.isBadged {
                Text("CHOICE")
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }

            Text(product.source)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private func priceRow(_ product: Product) -> some View {
        PriceView(
            price: product.price,
            currency: product.currency,
            originalPrice: product.originalPrice,
            convertedPrice: product.convertedPrice,
            showConverted: true,
            size: .large
        )
    }

    // MARK: - Warnings

    private func warningsSection(_ product: Product) -> some View {
        Group {
            if !product.warnings.isEmpty {
                WarningCardView(items: product.warnings)
                    .padding(.horizontal, AppSpacing.screenHorizontal)
            }
        }
    }

    // MARK: - Description

    private func descriptionSection(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("商品简介")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.textPrimary)

            Text(product.description)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
                .lineSpacing(6)
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
    }

    // MARK: - Highlights

    private func highlightsSection(_ product: Product) -> some View {
        Group {
            if !product.highlights.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("核心亮点")
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColors.textPrimary)
                        .padding(.horizontal, AppSpacing.screenHorizontal)

                    VStack(spacing: 0) {
                        ForEach(Array(product.highlights.enumerated()), id: \.element.id) { index, highlight in
                            HighlightRowView(highlight: highlight)
                            if index < product.highlights.count - 1 {
                                Divider().padding(.leading, 68)
                            }
                        }
                    }
                    .background(AppColors.backgroundCard)
                    .clipShape(RoundedRectangle(cornerRadius: AppStyle.cardRadius))
                    .padding(.horizontal, AppSpacing.screenHorizontal)
                }
            }
        }
    }

    // MARK: - Assistant Actions

    private var assistantSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("购物助手建议")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.sm) {
                    ForEach(viewModel.assistantActions) { action in
                        Button { } label: {
                            Text(action.label)
                                .font(AppTypography.subheadline)
                                .foregroundStyle(AppColors.primaryBlue)
                                .padding(.horizontal, AppSpacing.md)
                                .padding(.vertical, AppSpacing.sm)
                                .background(AppColors.primaryBlueLight)
                                .clipShape(RoundedRectangle(cornerRadius: AppStyle.buttonRadius))
                        }
                    }
                }
            }
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
    }

    // MARK: - CTA Button

    private func ctaButton(_ product: Product) -> some View {
        Button {
            if let url = URL(string: product.amazonURL) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "cart.fill")
                Text("去 Amazon 查看")
                Spacer()
                Image(systemName: "link")
            }
            .primaryButtonStyle()
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.backgroundPrimary)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(productID: "B0BSHF7WHT")
    }
    .environment(SettingsStore())
    .environment(FavoritesStore(service: LocalFavoritesService()))
}
