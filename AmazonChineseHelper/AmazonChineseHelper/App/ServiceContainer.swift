import Foundation

final class ServiceContainer {
    let productService: ProductServiceProtocol
    let favoritesService: FavoritesServiceProtocol

    init() {
        self.productService = MockProductService()
        self.favoritesService = LocalFavoritesService()
    }

    static let shared = ServiceContainer()
}
