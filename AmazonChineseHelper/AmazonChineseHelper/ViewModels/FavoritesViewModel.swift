import Foundation

enum FavoritesFilter: String, CaseIterable {
    case all
    case onSale
    case recent
}

@Observable
final class FavoritesViewModel {

    var products: [Product] = []
    var isLoading = false
    var activeFilter: FavoritesFilter = .all

    private let productService: ProductServiceProtocol

    init(productService: ProductServiceProtocol = ServiceContainer.shared.productService) {
        self.productService = productService
    }

    func loadFavorites(ids: Set<String>) async {
        guard !ids.isEmpty else {
            products = []
            return
        }

        isLoading = true
        var loaded: [Product] = []
        for id in ids {
            if let product = try? await productService.getProductDetail(id: id) {
                loaded.append(product)
            }
        }
        products = loaded
        isLoading = false
    }

    var filteredProducts: [Product] {
        switch activeFilter {
        case .all:
            return products
        case .onSale:
            return products.filter(\.isOnSale)
        case .recent:
            return Array(products.prefix(3))
        }
    }

    func chipLabel(for filter: FavoritesFilter, totalCount: Int) -> String {
        switch filter {
        case .all:    return "全部收藏 (\(totalCount))"
        case .onSale: return "降价商品"
        case .recent: return "近期查看"
        }
    }
}
