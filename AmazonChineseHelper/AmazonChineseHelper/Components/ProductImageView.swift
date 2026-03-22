import SwiftUI

struct ProductImageView: View {
    let imageName: String
    var size: CGFloat = 80
    var cornerRadius: CGFloat = AppStyle.imageRadius

    var body: some View {
        Group {
            if imageName.hasPrefix("http") {
                AsyncImage(url: URL(string: imageName)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    placeholder
                }
            } else {
                Image(systemName: imageName)
                    .font(.system(size: size * 0.35))
                    .foregroundStyle(AppColors.primaryBlue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.primaryBlueLight)
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(AppColors.backgroundSecondary)
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(AppColors.textTertiary)
            }
    }
}

#Preview {
    HStack(spacing: 16) {
        ProductImageView(imageName: "ipad.landscape", size: 80)
        ProductImageView(imageName: "headphones", size: 64)
        ProductImageView(imageName: "cup.and.saucer.fill", size: 100)
    }
    .padding()
}
