import Foundation

protocol FavoritesServiceProtocol {
    func getFavoriteIDs() -> Set<String>
    func addFavorite(productID: String)
    func removeFavorite(productID: String)
    func isFavorite(productID: String) -> Bool
}
