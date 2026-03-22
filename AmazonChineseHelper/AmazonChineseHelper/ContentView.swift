import SwiftUI

// MARK: - Model

struct Product: Identifiable {
    let id = UUID()
    let title: String
    let chineseTitle: String
    let price: Double
    let systemImage: String
}

// MARK: - Mock Data

let mockProducts: [Product] = [
    Product(
        title: "Philips Sonicare Electric Toothbrush HX9911",
        chineseTitle: "飞利浦声波电动牙刷 HX9911",
        price: 149.95,
        systemImage: "mouth"
    ),
    Product(
        title: "Apple iPad Pro 11-inch M2, 128GB",
        chineseTitle: "iPad Pro 11英寸 M2 芯片, 128GB",
        price: 799.00,
        systemImage: "ipad"
    ),
    Product(
        title: "Noise Cancelling Wireless Headphones",
        chineseTitle: "降噪无线耳机 - 皮质白",
        price: 199.00,
        systemImage: "headphones"
    ),
    Product(
        title: "Smart Electric Kettle, 1.7L Stainless Steel",
        chineseTitle: "智能恒温电水壶 1.7升不锈钢",
        price: 45.50,
        systemImage: "cup.and.saucer"
    ),
    Product(
        title: "Nike Air Zoom Pegasus 39 Running Shoes",
        chineseTitle: "耐克 Air Zoom Pegasus 39 男士跑鞋",
        price: 119.99,
        systemImage: "shoe"
    ),
]

// MARK: - Product Row

struct ProductRow: View {
    let product: Product

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: product.systemImage)
                .font(.title)
                .frame(width: 64, height: 64)
                .foregroundStyle(.white)
                .background(Color.blue.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.chineseTitle)
                    .font(.headline)

                Text(product.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(String(format: "$%.2f", product.price))
                    .font(.body.bold().monospacedDigit())
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }
}

// MARK: - Home Screen

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("你好，找点什么？")
                    .font(.largeTitle.bold())
                    .padding(.top, 8)

                ForEach(mockProducts) { product in
                    ProductRow(product: product)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("亚马逊中文购物助手")
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
