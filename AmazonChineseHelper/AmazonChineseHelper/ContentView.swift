import SwiftUI

enum AppTab: Hashable {
    case home
    case favorites
    case settings
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @Environment(SettingsStore.self) private var settingsStore

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("首页", systemImage: "house.fill", value: .home) {
                HomeView()
            }
            Tab("收藏", systemImage: "heart.fill", value: .favorites) {
                NavigationStack {
                    FavoritesView()
                }
            }
            Tab("设置", systemImage: "gearshape.fill", value: .settings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .tint(AppColors.primaryBlue)
        .dynamicTypeSize(settingsStore.isLargeTextMode ? .xxxLarge : .large)
    }
}

#Preview {
    ContentView()
        .environment(SettingsStore())
        .environment(FavoritesStore(service: LocalFavoritesService()))
}
