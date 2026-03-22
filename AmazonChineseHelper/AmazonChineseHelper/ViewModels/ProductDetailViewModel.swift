import Foundation

@Observable
final class ProductDetailViewModel {
    var product: Product?
    var isLoading = true
    var errorMessage: String?

    private let productID: String
    private let productService: ProductServiceProtocol

    init(productID: String, productService: ProductServiceProtocol = ServiceContainer.shared.productService) {
        self.productID = productID
        self.productService = productService
    }

    func loadProduct() async {
        isLoading = true
        errorMessage = nil
        do {
            product = try await productService.getProductDetail(id: productID)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    var assistantActions: [AssistantAction] {
        [
            AssistantAction(id: "d1", label: "比较历史最低价", type: .priceComparison),
            AssistantAction(id: "d2", label: "翻译全部评价", type: .reviewTranslation),
            AssistantAction(id: "d3", label: "尺码/尺寸建议", type: .sizing),
        ]
    }
}
