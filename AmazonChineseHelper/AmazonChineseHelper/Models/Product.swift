import Foundation

struct Product: Codable, Identifiable {
    let id: String
    let title: String
    let originalTitle: String
    let price: Double
    let currency: CurrencyUnit
    let convertedPrice: Double?
    let originalPrice: Double?
    let rating: Double
    let reviewCount: Int
    let imageNames: [String]
    let description: String
    let highlights: [ProductHighlight]
    let warnings: [String]
    let tags: [ProductTag]
    let source: String
    let amazonURL: String
    let categoryId: String
    let isBadged: Bool
    let isOnSale: Bool
}
