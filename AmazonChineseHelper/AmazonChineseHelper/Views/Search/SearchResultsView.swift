import SwiftUI

struct SearchResultsView: View {
    let initialQuery: String

    @State private var viewModel: SearchViewModel
    @Environment(FavoritesStore.self) private var favoritesStore

    init(initialQuery: String) {
        self.initialQuery = initialQuery
        self._viewModel = State(initialValue: SearchViewModel(query: initialQuery))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                searchBar
                filterBar
                resultCount

                if viewModel.isLoading {
                    loadingView
                } else {
                    productList
                    suggestionCard
                }
            }
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.backgroundSecondary)
        .navigationTitle("亚马逊中文购物助手")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.search()
        }
        .navigationDestination(for: String.self) { productID in
            ProductDetailView(productID: productID)
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        SearchBarView(text: $viewModel.query) {
            Task { await viewModel.search() }
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
    }

    // MARK: - Filters

    private var filterBar: some View {
        FilterChipBar(
            chips: viewModel.filterChips,
            selectedID: $viewModel.selectedFilterID
        )
        .padding(.horizontal, AppSpacing.screenHorizontal)
    }

    // MARK: - Result Count

    private var resultCount: some View {
        Group {
            if viewModel.totalCount > 0 {
                Text(viewModel.resultCountText)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .padding(.horizontal, AppSpacing.screenHorizontal)
            }
        }
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
            Text("正在搜索...")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.xxxl)
    }

    // MARK: - Product List

    private var productList: some View {
        LazyVStack(spacing: AppSpacing.md) {
            ForEach(viewModel.products) { product in
                NavigationLink(value: product.id) {
                    ProductCardSearch(
                        product: product,
                        isFavorite: favoritesStore.isFavorite(productID: product.id),
                        onFavoriteToggle: {
                            favoritesStore.toggle(productID: product.id)
                        }
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
    }

    // MARK: - Assistant Suggestion

    private var suggestionCard: some View {
        Group {
            if let suggestion = viewModel.suggestion {
                AssistantSuggestionCard(suggestion: suggestion)
                    .padding(.horizontal, AppSpacing.screenHorizontal)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchResultsView(initialQuery: "电动牙刷")
    }
    .environment(SettingsStore())
    .environment(FavoritesStore(service: LocalFavoritesService()))
}
