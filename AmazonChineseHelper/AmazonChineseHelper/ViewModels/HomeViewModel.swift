import Foundation

@Observable
final class HomeViewModel {
    var categories: [ProductCategory] = []
    var frequentlyBought: [Product] = []
    var recommendations: [Product] = []
    var isLoading = false
    var searchQuery = ""

    private let productService: ProductServiceProtocol

    init(productService: ProductServiceProtocol = ServiceContainer.shared.productService) {
        self.productService = productService
    }

    func loadData() async {
        isLoading = true
        do {
            async let cats = productService.getCategories()
            async let freq = productService.getFrequentlyBought()
            async let recs = productService.getRecommendations()

            categories = try await cats
            frequentlyBought = try await freq
            recommendations = try await recs
        } catch {
            print("Failed to load home data: \(error)")
        }
        isLoading = false
    }
}
