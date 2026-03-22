import Foundation

@Observable
final class FavoritesStore {

    private(set) var favoriteIDs: Set<String>

    private let service: FavoritesServiceProtocol

    init(service: FavoritesServiceProtocol) {
        self.service = service
        self.favoriteIDs = service.getFavoriteIDs()
    }

    func add(productID: String) {
        service.addFavorite(productID: productID)
        favoriteIDs.insert(productID)
    }

    func remove(productID: String) {
        service.removeFavorite(productID: productID)
        favoriteIDs.remove(productID)
    }

    func toggle(productID: String) {
        if isFavorite(productID: productID) {
            remove(productID: productID)
        } else {
            add(productID: productID)
        }
    }

    func isFavorite(productID: String) -> Bool {
        favoriteIDs.contains(productID)
    }
}
