import Foundation

enum SortOption: String, CaseIterable {
    case smart = "智能排序"
    case priceLowToHigh = "价格低到高"
    case priceHighToLow = "价格高到低"
}

struct SearchFilter {
    var sortBy: SortOption = .smart
    var priceRange: ClosedRange<Double>?
    var categoryId: String?

    static let `default` = SearchFilter()
}
