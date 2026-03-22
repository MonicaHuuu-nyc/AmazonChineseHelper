import SwiftUI

struct ChipItem: Identifiable {
    let id: String
    let label: String
    var icon: String? = nil
}

struct FilterChipBar: View {
    let chips: [ChipItem]
    @Binding var selectedID: String?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(chips) { chip in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedID = selectedID == chip.id ? nil : chip.id
                        }
                    } label: {
                        HStack(spacing: AppSpacing.xs) {
                            if let icon = chip.icon {
                                Image(systemName: icon)
                                    .font(.caption)
                            }
                            Text(chip.label)
                        }
                        .chipStyle(isSelected: selectedID == chip.id)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selected: String? = "smart"

    FilterChipBar(
        chips: [
            ChipItem(id: "smart", label: "智能排序", icon: "line.3.horizontal.decrease"),
            ChipItem(id: "price", label: "价格", icon: "chevron.down"),
            ChipItem(id: "translation", label: "翻译偏好", icon: "chevron.down"),
        ],
        selectedID: $selected
    )
    .padding()
}
