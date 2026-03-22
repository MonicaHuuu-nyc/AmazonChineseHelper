import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var navigateToSearch = false
    @State private var searchQuery = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.sectionGap) {
                greetingSection
                searchSection
                categorySection
                frequentlyBoughtSection
                recommendationsSection
            }
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.backgroundSecondary)
        .navigationTitle("亚马逊中文购物助手")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadData()
        }
        .navigationDestination(for: String.self) { productID in
            ProductDetailView(productID: productID)
        }
        .navigationDestination(isPresented: $navigateToSearch) {
            SearchResultsView(initialQuery: searchQuery)
        }
    }

    // MARK: - Greeting

    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(GreetingHelper.currentGreeting())
                .font(AppTypography.subheadline)
                .foregroundStyle(AppColors.textSecondary)

            Text("你好，找点什么？")
                .font(AppTypography.largeTitle)
                .foregroundStyle(AppColors.textPrimary)
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.sm)
    }

    // MARK: - Search

    private var searchSection: some View {
        SearchBarView(text: $searchQuery) {
            guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            navigateToSearch = true
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
    }

    // MARK: - Categories

    private var categorySection: some View {
        Group {
            if !viewModel.categories.isEmpty {
                CategoryGridView(categories: viewModel.categories) { category in
                    searchQuery = category.name
                    navigateToSearch = true
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
            }
        }
    }

    // MARK: - Frequently Bought

    private var frequentlyBoughtSection: some View {
        Group {
            if !viewModel.frequentlyBought.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeaderView(title: "常买商品")
                        .padding(.horizontal, AppSpacing.screenHorizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppSpacing.md) {
                            ForEach(viewModel.frequentlyBought) { product in
                                NavigationLink(value: product.id) {
                                    ProductCardCompact(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, AppSpacing.screenHorizontal)
                    }
                }
            }
        }
    }

    // MARK: - Recommendations

    private var recommendationsSection: some View {
        Group {
            if !viewModel.recommendations.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeaderView(title: "为你推荐")
                        .padding(.horizontal, AppSpacing.screenHorizontal)

                    LazyVStack(spacing: AppSpacing.md) {
                        ForEach(viewModel.recommendations) { product in
                            NavigationLink(value: product.id) {
                                ProductCardRecommendation(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, AppSpacing.screenHorizontal)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(SettingsStore())
    .environment(FavoritesStore(service: LocalFavoritesService()))
}
