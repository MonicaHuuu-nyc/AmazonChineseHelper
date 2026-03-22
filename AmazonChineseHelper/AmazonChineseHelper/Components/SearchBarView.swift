import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var placeholder: String = "用中文搜索商品"
    var onSubmit: () -> Void = {}

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(AppColors.textTertiary)

                TextField(placeholder, text: $text)
                    .font(AppTypography.body)
                    .submitLabel(.search)
                    .onSubmit(onSubmit)

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(AppColors.textTertiary)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: AppStyle.imageRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppStyle.imageRadius)
                    .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
            )

            Button(action: onSubmit) {
                Text("搜索")
                    .font(AppTypography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                    .background(AppColors.primaryBlue)
                    .clipShape(RoundedRectangle(cornerRadius: AppStyle.imageRadius))
            }
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    @Previewable @State var filledText = "电动牙刷"

    VStack(spacing: 20) {
        SearchBarView(text: $text)
        SearchBarView(text: $filledText)
    }
    .padding()
    .background(AppColors.backgroundSecondary)
}
