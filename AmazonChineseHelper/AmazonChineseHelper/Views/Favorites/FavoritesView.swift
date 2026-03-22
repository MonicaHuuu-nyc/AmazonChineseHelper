import SwiftUI

struct FavoritesView: View {
    @State private var viewModel = FavoritesViewModel()
    @Environment(FavoritesStore.self) private var favoritesStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                header
                filterChips

                if viewModel.isLoading {
                    loadingView
                } else if favoritesStore.favoriteIDs.isEmpty {
                    emptyState
                } else if viewModel.filteredProducts.isEmpty {
                    filterEmptyState
                } else {
                    productList
                }
            }
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.backgroundSecondary)
        .navigationTitle("亚马逊中文购物助手")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: favoritesStore.favoriteIDs) {
            await viewModel.loadFavorites(ids: favoritesStore.favoriteIDs)
        }
        .navigationDestination(for: String.self) { productID in
            ProductDetailView(productID: productID)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("我的收藏")
                .font(AppTypography.largeTitle)
                .foregroundStyle(AppColors.textPrimary)

            Text("为您精心挑选的愿望清单")
                .font(AppTypography.subheadline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.lg)
    }

    // MARK: - Filter Chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(FavoritesFilter.allCases, id: \.self) { filter in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.activeFilter = filter
                        }
                    } label: {
                        Text(viewModel.chipLabel(for: filter, totalCount: favoritesStore.favoriteIDs.count))
                            .chipStyle(isSelected: viewModel.activeFilter == filter)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
        }
    }

    // MARK: - Product List

    private var productList: some View {
        LazyVStack(spacing: AppSpacing.md) {
            ForEach(viewModel.filteredProducts) { product in
                NavigationLink(value: product.id) {
                    ProductCardFavorite(product: product) {
                        withAnimation {
                            favoritesStore.remove(productID: product.id)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
    }

    // MARK: - Empty States

    private var emptyState: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "heart.slash")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.textTertiary)

            Text("还没有收藏商品")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.textSecondary)

            Text("浏览商品时点击爱心即可收藏")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.xxxl)
    }

    private var filterEmptyState: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "tag.slash")
                .font(.system(size: 36))
                .foregroundStyle(AppColors.textTertiary)

            Text("没有符合条件的商品")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.xxxl)
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
            Text("加载收藏...")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.xxxl)
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
    .environment(SettingsStore())
    .environment(FavoritesStore(service: LocalFavoritesService()))
}
