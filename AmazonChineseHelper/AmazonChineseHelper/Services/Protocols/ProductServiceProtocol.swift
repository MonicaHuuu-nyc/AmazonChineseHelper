import Foundation

protocol ProductServiceProtocol {
    func searchProducts(query: String, filter: SearchFilter?) async throws -> SearchResult
    func getProductDetail(id: String) async throws -> Product
    func getCategories() async throws -> [ProductCategory]
    func getFrequentlyBought() async throws -> [Product]
    func getRecommendations() async throws -> [Product]
}
