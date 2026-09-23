import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - 拍立得照片卡風格正面
struct FortuneCardFrontView: View {
    let card: FortuneCard
    #if canImport(UIKit)
    var preloadedImage: UIImage? = nil
    #endif
    var allowsNetworkLoading: Bool = true
    var isFailed: Bool = false
    var onToggleFavorite: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 上半部：拍立得照片區域
            ZStack(alignment: .topTrailing) {
                // 貓咪照片
                catPhotoView
                    .frame(width: 298, height: 210)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.black.opacity(0.04), lineWidth: 1)
                    )
                
                // 右上角收藏愛心按鈕
                Button {
                    HapticManager.light()
                    onToggleFavorite?()
                } label: {
                    Image(systemName: card.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(card.isFavorite ? Color(hex: "E64A4A") : Color.catDarkBrown)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 2)
                }
                .padding(10)
                .buttonStyle(.plain)
            }
            .padding([.top, .horizontal], 16)
            
            // MARK: - 下半部：運勢資訊與宜忌語錄
            VStack(spacing: 10) {
                // 標籤列：稀有度 + 類別 + 幸運色
                HStack(spacing: 6) {
                    // 稀有度 Badge
                    Text(card.rarity.title)
                        .font(.huninn(size: 11))
                        .foregroundColor(card.rarity.badgeColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(card.rarity.badgeBackgroundColor)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(card.rarity.badgeColor.opacity(0.3), lineWidth: 1)
                        )
                    
                    // 類別 Badge
                    HStack(spacing: 3) {
                        Image(systemName: card.category.iconName)
                            .font(.system(size: 10, weight: .bold))
                        Text(card.category.title)
                            .font(.huninn(size: 11))
                    }
                    .foregroundColor(.catCaramel)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.catLightOrange.opacity(0.5))
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                    // 幸運色色點
                    HStack(spacing: 4) {
                        Circle()
                            .fill(card.rarity.badgeColor)
                            .frame(width: 7, height: 7)
                        Text(card.luckyColor)
                            .font(.huninn(size: 10))
                            .foregroundColor(.catSecondaryBrown)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color(hex: "F7F3EB"))
                    .clipShape(Capsule())
                }
                .padding(.top, 12)
                
                // 主標題
                Text(card.title)
                    .font(.huninn(size: 21))
                    .foregroundColor(.catDarkBrown)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // 和風細分隔線
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.catCardBorder)
                        .frame(height: 1)
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.catGold)
                    Rectangle()
                        .fill(Color.catCardBorder)
                        .frame(height: 1)
                }
                
                // 今日宜／忌 語錄區塊
                let advice = card.parsedAdvice
                VStack(alignment: .leading, spacing: 8) {
                    if !advice.good.isEmpty {
                        HStack(alignment: .center, spacing: 8) {
                            Text("宜")
                                .font(.huninn(size: 10))
                                .foregroundColor(.catGoodGreen)
                                .frame(width: 20, height: 20)
                                .background(Color.catGoodBg)
                                .clipShape(Circle())
                            
                            Text(advice.good)
                                .font(.huninn(size: 12))
                                .foregroundColor(.catDarkBrown)
                                .lineSpacing(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    if !advice.bad.isEmpty {
                        HStack(alignment: .center, spacing: 8) {
                            Text("忌")
                                .font(.huninn(size: 10))
                                .foregroundColor(.catBadRed)
                                .frame(width: 20, height: 20)
                                .background(Color.catBadBg)
                                .clipShape(Circle())
                            
                            Text(advice.bad)
                                .font(.huninn(size: 12))
                                .foregroundColor(.catDarkBrown)
                                .lineSpacing(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(hex: "FAF8F4"))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Spacer(minLength: 4)
                
                // 底部防偽印記風格文字
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "seal.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.catGold)
                        Text("喵神社認證")
                            .font(.huninn(size: 9))
                            .foregroundColor(.catSecondaryBrown)
                    }
                    
                    Spacer()
                    
                    Text("爪印為憑 · No.\(card.id.uuidString.prefix(6))")
                        .font(.huninn(size: 9))
                        .foregroundColor(.catMutedBrown)
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 16)
        }
        .frame(width: 330, height: 520)
        .background(Color.catCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.catCardBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
        .shadow(color: Color.catCaramel.opacity(0.06), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - 貓咪照片顯示視圖（依序檢查預載圖、本機儲存檔、最後使用網路載入或佔位）
    @ViewBuilder
    private var catPhotoView: some View {
        #if canImport(UIKit)
        if let preloaded = preloadedImage {
            Image(uiImage: preloaded)
                .resizable()
                .scaledToFill()
                .frame(width: 298, height: 210)
                .clipped()
        } else if let localName = card.localImageFileName,
                  let localImage = FortuneImageManager.shared.loadImage(fileName: localName) {
            Image(uiImage: localImage)
                .resizable()
                .scaledToFill()
                .frame(width: 298, height: 210)
                .clipped()
        } else if allowsNetworkLoading {
            networkAsyncImage
        } else if isFailed {
            failurePlaceholderView
        } else {
            loadingPlaceholderView
        }
        #else
        if allowsNetworkLoading {
            networkAsyncImage
        } else if isFailed {
            failurePlaceholderView
        } else {
            loadingPlaceholderView
        }
        #endif
    }
    
    private var loadingPlaceholderView: some View {
        ZStack {
            Color(hex: "F6EFE6")
            VStack(spacing: 8) {
                ProgressView()
                    .tint(.catCaramel)
                Text("喵咪照片下載中...")
                    .font(.huninn(size: 11))
                    .foregroundColor(.catSecondaryBrown)
            }
        }
    }
    
    private var failurePlaceholderView: some View {
        ZStack {
            Color(hex: "F5ECE1")
            VStack(spacing: 8) {
                Image(systemName: "cat.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.catCaramel.opacity(0.8))
                Text("喵星訊號接收中 🐾")
                    .font(.huninn(size: 12))
                    .foregroundColor(.catSecondaryBrown)
            }
        }
    }
    
    private var networkAsyncImage: some View {
        AsyncImage(url: URL(string: card.imageURLString)) { phase in
            switch phase {
            case .empty:
                loadingPlaceholderView
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 298, height: 210)
                    .clipped()
            case .failure:
                failurePlaceholderView
            @unknown default:
                Color(hex: "F5ECE1")
            }
        }
    }
}

#Preview {
    let mockCard = FortuneData.randomCard()
    FortuneCardFrontView(card: mockCard)
        .padding()
        .background(Color.catBackground)
}
