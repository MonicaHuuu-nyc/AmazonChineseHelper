import SwiftUI

struct CategoryGridView: View {
    let categories: [ProductCategory]
    var onSelect: (ProductCategory) -> Void = { _ in }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: AppSpacing.lg), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.lg) {
            ForEach(categories) { category in
                Button {
                    onSelect(category)
                } label: {
                    VStack(spacing: AppSpacing.sm) {
                        Image(systemName: category.iconName)
                            .font(.title2)
                            .foregroundStyle(AppColors.primaryBlue)
                            .frame(width: 52, height: 52)
                            .background(AppColors.primaryBlueLight)
                            .clipShape(RoundedRectangle(cornerRadius: AppStyle.imageRadius))

                        Text(category.name)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryGridView(categories: [
        ProductCategory(id: "hot", name: "热门产品", iconName: "flame.fill"),
        ProductCategory(id: "beauty", name: "美妆", iconName: "sparkles"),
        ProductCategory(id: "food", name: "美食", iconName: "fork.knife"),
        ProductCategory(id: "electronics", name: "通讯", iconName: "iphone"),
        ProductCategory(id: "pets", name: "宠物用品", iconName: "pawprint.fill"),
        ProductCategory(id: "cleaning", name: "清洁", iconName: "bubbles.and.sparkles"),
    ])
    .padding()
}
