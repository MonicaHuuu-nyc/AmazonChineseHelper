import Foundation

final class MockProductService: ProductServiceProtocol {

    private var cachedProducts: [Product]?
    private var cachedCategories: [ProductCategory]?
    private var recommendationData: RecommendationData?

    private struct RecommendationData: Codable {
        let frequentlyBoughtIds: [String]
        let recommendedIds: [String]
    }

    // MARK: - Protocol

    func searchProducts(query: String, filter: SearchFilter?) async throws -> SearchResult {
        try await simulateLatency()

        let allProducts = try loadProducts()
        let lowered = query.lowercased()

        let filtered = allProducts.filter { product in
            product.title.lowercased().contains(lowered) ||
            product.originalTitle.lowercased().contains(lowered) ||
            product.categoryId.lowercased().contains(lowered)
        }

        let sorted = applySorting(filtered, sortBy: filter?.sortBy ?? .smart)

        let suggestion = AssistantSuggestion(
            message: "正在为您搜索关于 \"\(query)\" 的评论摘要。大多数用户表示在亚马逊购买飞利浦品牌更具价格优势，但请注意查看插头电压是否适配您的地区。",
            actions: [
                AssistantAction(id: "a1", label: "查看评论翻译", type: .reviewTranslation),
                AssistantAction(id: "a2", label: "比较历史价格", type: .priceHistory)
            ]
        )

        return SearchResult(
            products: sorted,
            totalCount: sorted.count * 103,
            suggestion: suggestion
        )
    }

    func getProductDetail(id: String) async throws -> Product {
        try await simulateLatency()
        let products = try loadProducts()
        guard let product = products.first(where: { $0.id == id }) else {
            throw MockServiceError.productNotFound
        }
        return product
    }

    func getCategories() async throws -> [ProductCategory] {
        try await simulateLatency()
        return try loadCategories()
    }

    func getFrequentlyBought() async throws -> [Product] {
        try await simulateLatency()
        let data = try loadRecommendations()
        let products = try loadProducts()
        return data.frequentlyBoughtIds.compactMap { id in
            products.first { $0.id == id }
        }
    }

    func getRecommendations() async throws -> [Product] {
        try await simulateLatency()
        let data = try loadRecommendations()
        let products = try loadProducts()
        return data.recommendedIds.compactMap { id in
            products.first { $0.id == id }
        }
    }

    // MARK: - Private

    private func simulateLatency() async throws {
        try await Task.sleep(for: .milliseconds(300))
    }

    private func loadProducts() throws -> [Product] {
        if let cached = cachedProducts { return cached }
        let products: [Product] = try loadJSON("mock_products")
        cachedProducts = products
        return products
    }

    private func loadCategories() throws -> [ProductCategory] {
        if let cached = cachedCategories { return cached }
        let categories: [ProductCategory] = try loadJSON("mock_categories")
        cachedCategories = categories
        return categories
    }

    private func loadRecommendations() throws -> RecommendationData {
        if let cached = recommendationData { return cached }
        let data: RecommendationData = try loadJSON("mock_recommendations")
        recommendationData = data
        return data
    }

    private func loadJSON<T: Decodable>(_ filename: String) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw MockServiceError.fileNotFound(filename)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func applySorting(_ products: [Product], sortBy: SortOption) -> [Product] {
        switch sortBy {
        case .smart:
            return products
        case .priceLowToHigh:
            return products.sorted { $0.price < $1.price }
        case .priceHighToLow:
            return products.sorted { $0.price > $1.price }
        }
    }
}

enum MockServiceError: LocalizedError {
    case fileNotFound(String)
    case productNotFound

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name): return "找不到数据文件: \(name)"
        case .productNotFound:        return "找不到该商品"
        }
    }
}
