import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .primaryButtonStyle()
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "去 Amazon 查看", icon: "cart.fill") { }
        PrimaryButton(title: "搜索") { }
    }
    .padding()
}
