import Foundation

final class LocalFavoritesService: FavoritesServiceProtocol {

    private let storageKey = "saved_favorite_ids"

    func getFavoriteIDs() -> Set<String> {
        readFromDefaults()
    }

    func addFavorite(productID: String) {
        var ids = readFromDefaults()
        ids.insert(productID)
        writeToDefaults(ids)
    }

    func removeFavorite(productID: String) {
        var ids = readFromDefaults()
        ids.remove(productID)
        writeToDefaults(ids)
    }

    func isFavorite(productID: String) -> Bool {
        readFromDefaults().contains(productID)
    }

    // MARK: - Private

    private func readFromDefaults() -> Set<String> {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let ids = try? JSONDecoder().decode(Set<String>.self, from: data) else {
            return []
        }
        return ids
    }

    private func writeToDefaults(_ ids: Set<String>) {
        guard let data = try? JSONEncoder().encode(ids) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
