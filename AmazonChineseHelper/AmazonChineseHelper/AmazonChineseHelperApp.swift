import SwiftUI

@main
struct AmazonChineseHelperApp: App {

    @State private var settingsStore = SettingsStore()
    @State private var favoritesStore = FavoritesStore(
        service: ServiceContainer.shared.favoritesService
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settingsStore)
                .environment(favoritesStore)
        }
    }
}
