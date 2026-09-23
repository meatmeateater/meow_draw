import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - 籤卡詳情檢視頁
struct CardDetailView: View {
    @Binding var card: FortuneCard
    var onToggleFavorite: () -> Void
    var onDelete: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    
    @State private var renderedShareImage: Image? = nil
    #if canImport(UIKit)
    @State private var cardImage: UIImage? = nil
    #endif
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 正面拍立得卡片展示
                #if canImport(UIKit)
                FortuneCardFrontView(card: card, preloadedImage: cardImage, onToggleFavorite: {
                    onToggleFavorite()
                })
                .padding(.top, 16)
                #else
                FortuneCardFrontView(card: card, onToggleFavorite: {
                    onToggleFavorite()
                })
                .padding(.top, 16)
                #endif
                
                // 功能操作按鈕列
                VStack(spacing: 12) {
                    // 收藏切換膠囊按鈕
                    Button {
                        HapticManager.light()
                        onToggleFavorite()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: card.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(card.isFavorite ? Color(hex: "E64A4A") : .catDarkBrown)
                            Text(card.isFavorite ? "已加入收藏" : "加入收藏")
                                .font(.huninn(size: 15))
                                .foregroundColor(.catDarkBrown)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.catCardBackground)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.catCardBorder, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                    }
                    .buttonStyle(.plain)
                    
                    // 分享按鈕
                    if let shareImage = renderedShareImage {
                        ShareLink(
                            item: shareImage,
                            preview: SharePreview("喵運籤 - \(card.title)", image: shareImage)
                        ) {
                            HStack(spacing: 8) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16, weight: .bold))
                                Text("分享這張喵運卡")
                                    .font(.huninn(size: 15))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [Color.catCaramel, Color(hex: "BE6545")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: Color.catCaramel.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    } else {
                        Button {
                            // 圖片渲染中，按鈕暫時停用
                        } label: {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .scaleEffect(0.85)
                                    .tint(.catSecondaryBrown)
                                Text("分享圖片準備中…")
                                    .font(.huninn(size: 15))
                            }
                            .foregroundColor(.catSecondaryBrown)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.catCardBackground)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(Color.catCardBorder, lineWidth: 1)
                            )
                        }
                        .disabled(true)
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            }
        }
        .background(Color.catBackground.ignoresSafeArea())
        .navigationTitle("喵籤詳情")
        .inlineNavigationBarTitle()
        .toolbar {
            if onDelete != nil {
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.catBadRed)
                    }
                }
            }
        }
        .confirmationDialog("確定要刪除這張喵籤嗎？", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("刪除籤卡", role: .destructive) {
                HapticManager.medium()
                onDelete?()
                dismiss()
            }
            Button("取消", role: .cancel) {}
        }
        .task {
            #if canImport(UIKit)
            if let (image, fileName) = await FortuneImageManager.shared.getOrDownloadImage(for: card) {
                self.cardImage = image
                if card.localImageFileName == nil {
                    card.localImageFileName = fileName
                }
            }
            #endif
            renderCardImage()
        }
    }
    
    @MainActor
    private func renderCardImage() {
        #if canImport(UIKit)
        let exportView = FortuneCardFrontView(card: card, preloadedImage: cardImage, onToggleFavorite: nil)
            .frame(width: 330, height: 520)
        #else
        let exportView = FortuneCardFrontView(card: card, onToggleFavorite: nil)
            .frame(width: 330, height: 520)
        #endif
        let renderer = ImageRenderer(content: exportView)
        renderer.scale = 3.0
        #if canImport(UIKit)
        if let uiImage = renderer.uiImage {
            self.renderedShareImage = Image(uiImage: uiImage)
        }
        #elseif canImport(AppKit)
        if let nsImage = renderer.nsImage {
            self.renderedShareImage = Image(nsImage: nsImage)
        }
        #endif
    }
}
