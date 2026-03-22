import SwiftUI

struct TagView: View {
    let tag: ProductTag

    var body: some View {
        Text(tag.label)
            .font(AppTypography.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xs)
            .foregroundStyle(AppColors.tagForeground(for: tag.style))
            .background(AppColors.tagBackground(for: tag.style))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    HStack {
        TagView(tag: ProductTag(label: "人气之选", style: .popular))
        TagView(tag: ProductTag(label: "高端旗舰", style: .premium))
        TagView(tag: ProductTag(label: "高科技", style: .highTech))
        TagView(tag: ProductTag(label: "性价比高", style: .value))
        TagView(tag: ProductTag(label: "育儿推荐", style: .kids))
    }
    .padding()
}
