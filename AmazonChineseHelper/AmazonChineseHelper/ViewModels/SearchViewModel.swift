import Foundation

@Observable
final class SearchViewModel {
    var query: String
    var products: [Product] = []
    var totalCount = 0
    var suggestion: AssistantSuggestion?
    var isLoading = false
    var selectedFilterID: String? = "smart"

    private let productService: ProductServiceProtocol

    init(query: String, productService: ProductServiceProtocol = ServiceContainer.shared.productService) {
        self.query = query
        self.productService = productService
    }

    func search() async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isLoading = true
        do {
            let filter = SearchFilter(sortBy: currentSortOption)
            let result = try await productService.searchProducts(query: query, filter: filter)
            products = result.products
            totalCount = result.totalCount
            suggestion = result.suggestion
        } catch {
            print("Search failed: \(error)")
        }
        isLoading = false
    }

    var currentSortOption: SortOption {
        switch selectedFilterID {
        case "price_low":  return .priceLowToHigh
        case "price_high": return .priceHighToLow
        default:           return .smart
        }
    }

    var filterChips: [ChipItem] {
        [
            ChipItem(id: "smart", label: "智能排序", icon: "line.3.horizontal.decrease"),
            ChipItem(id: "price", label: "价格", icon: "chevron.down"),
            ChipItem(id: "translation", label: "翻译偏好", icon: "chevron.down"),
        ]
    }

    var resultCountText: String {
        "找到约 \(formattedCount) 条结果"
    }

    private var formattedCount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: totalCount)) ?? "\(totalCount)"
    }
}
