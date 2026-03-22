import SwiftUI

struct RatingView: View {
    let rating: Double
    let reviewCount: Int

    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            HStack(spacing: 1) {
                ForEach(0..<5) { index in
                    starImage(for: index)
                        .font(.caption2)
                        .foregroundStyle(AppColors.ratingGold)
                }
            }

            Text(String(format: "%.1f", rating))
                .font(AppTypography.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textPrimary)

            Text("(\(formattedCount)+ 评价)")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private func starImage(for index: Int) -> Image {
        let threshold = Double(index) + 0.5
        if rating >= Double(index + 1) {
            return Image(systemName: "star.fill")
        } else if rating >= threshold {
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            return Image(systemName: "star")
        }
    }

    private var formattedCount: String {
        if reviewCount >= 1000 {
            let thousands = Double(reviewCount) / 1000.0
            return String(format: "%.0fK", thousands)
        }
        return "\(reviewCount)"
    }
}

#Preview {
    VStack(spacing: 12) {
        RatingView(rating: 4.9, reviewCount: 12403)
        RatingView(rating: 3.5, reviewCount: 842)
        RatingView(rating: 5.0, reviewCount: 156)
    }
    .padding()
}
