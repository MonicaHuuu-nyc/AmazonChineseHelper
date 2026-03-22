import SwiftUI

struct SettingsView: View {
    @Environment(SettingsStore.self) private var settingsStore

    var body: some View {
        @Bindable var settings = settingsStore

        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                header
                displaySection(settings: $settings)
                supportSection
                appFooter
            }
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.backgroundSecondary)
        .navigationTitle("亚马逊中文购物助手")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("设置")
                .font(AppTypography.largeTitle)
                .foregroundStyle(AppColors.textPrimary)

            Text("个性化您的购物助手机器人")
                .font(AppTypography.subheadline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.lg)
    }

    // MARK: - Display & Text

    private func displaySection(settings: Bindable<SettingsStore>) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("显示与文字")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.screenHorizontal)

            VStack(spacing: 0) {
                largeTextRow(settings: settings)
                Divider().padding(.leading, 60)
                currencyRow(settings: settings)
            }
            .background(AppColors.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: AppStyle.cardRadius))
            .padding(.horizontal, AppSpacing.screenHorizontal)
        }
    }

    private func largeTextRow(settings: Bindable<SettingsStore>) -> some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "eye")
                .font(.title3)
                .foregroundStyle(AppColors.primaryBlue)
                .frame(width: 36, height: 36)
                .background(AppColors.primaryBlueLight)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text("大字体模式")
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.textPrimary)

                Text("专为长辈设计的全局字体放大功能")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            Toggle("", isOn: settings.isLargeTextMode)
                .labelsHidden()
                .tint(AppColors.primaryBlue)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.md)
    }

    private func currencyRow(settings: Bindable<SettingsStore>) -> some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                .font(.title3)
                .foregroundStyle(AppColors.primaryBlue)
                .frame(width: 36, height: 36)
                .background(AppColors.primaryBlueLight)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text("货币单位")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.textPrimary)

            Spacer()

            Picker("", selection: settings.preferredCurrency) {
                ForEach(CurrencyUnit.allCases, id: \.self) { currency in
                    Text(currency.displayName).tag(currency)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.md)
    }

    // MARK: - Support

    private var supportSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("支持")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.screenHorizontal)

            Button { } label: {
                HStack(spacing: AppSpacing.md) {
                    Image(systemName: "questionmark.circle")
                        .font(.title3)
                        .foregroundStyle(AppColors.primaryBlue)
                        .frame(width: 36, height: 36)
                        .background(AppColors.primaryBlueLight)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Text("帮助与关于")
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColors.textPrimary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(AppColors.textTertiary)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.md)
            }
            .background(AppColors.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: AppStyle.cardRadius))
            .padding(.horizontal, AppSpacing.screenHorizontal)
        }
    }

    // MARK: - Footer

    private var appFooter: some View {
        VStack(spacing: AppSpacing.xs) {
            Text("AMAZON CHINA HELPER")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textTertiary)

            Text("版本 1.0.0")
                .font(AppTypography.caption2)
                .foregroundStyle(AppColors.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.xxl)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(SettingsStore())
    .environment(FavoritesStore(service: LocalFavoritesService()))
}
