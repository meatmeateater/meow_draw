import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - 抽籤結果頁
struct ResultView: View {
    let initialCategory: FortuneCategory
    @Binding var history: [FortuneCard]
    
    @State private var currentCard: FortuneCard
    @State private var isFlipped = false
    @State private var isRedrawing = false
    @State private var renderedShareImage: Image? = nil
    #if canImport(UIKit)
    @State private var cardImage: UIImage? = nil
    #endif
    @State private var isImageLoading = false
    @State private var isImageLoadFailed = false
    @State private var isRenderFailed = false
    @State private var imageLoadTask: Task<Void, Never>? = nil
    @State private var redrawTask: Task<Void, Never>? = nil
    
    init(initialCategory: FortuneCategory, history: Binding<[FortuneCard]>) {
        self.initialCategory = initialCategory
        self._history = history
        let initialCard = FortuneData.randomCard(for: initialCategory)
        self._currentCard = State(initialValue: initialCard)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 提示文案
                VStack(spacing: 4) {
                    Text(isFlipped ? "✦ 今日專屬喵運已揭曉 ✦" : "✦ 虔心祈願，喵神賜籤 ✦")
                        .font(.huninn(size: 14))
                        .foregroundColor(.catCaramel)
                    
                    Text(isFlipped ? "點擊卡片可翻轉檢視背面" : "靜候揭籤，或點擊卡片翻開")
                        .font(.huninn(size: 12))
                        .foregroundColor(.catSecondaryBrown)
                }
                .padding(.top, 8)
                
                // 3D 翻牌卡片主體
                ZStack {
                    FortuneCardBackView()
                        .opacity(isFlipped ? 0 : 1)
                        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    
                    #if canImport(UIKit)
                    FortuneCardFrontView(
                        card: currentCard,
                        preloadedImage: cardImage,
                        allowsNetworkLoading: false,
                        isFailed: isImageLoadFailed,
                        onToggleFavorite: {
                            toggleFavorite()
                        }
                    )
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                    #else
                    FortuneCardFrontView(
                        card: currentCard,
                        allowsNetworkLoading: false,
                        isFailed: isImageLoadFailed,
                        onToggleFavorite: {
                            toggleFavorite()
                        }
                    )
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                    #endif
                }
                .animation(.spring(response: 0.7, dampingFraction: 0.75), value: isFlipped)
                .onTapGesture {
                    HapticManager.selection()
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                        isFlipped.toggle()
                    }
                }
                .padding(.horizontal, 20)
                
                // 翻開後展示兩大功能按鈕
                if isFlipped {
                    VStack(spacing: 12) {
                        // 1. 分享今日運勢卡按鈕
                        if let shareImage = renderedShareImage {
                            ShareLink(
                                item: shareImage,
                                preview: SharePreview("喵運籤 - \(currentCard.title)", image: shareImage)
                            ) {
                                HStack(spacing: 8) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("分享今日運勢卡")
                                        .font(.huninn(size: 16))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    LinearGradient(
                                        colors: [Color.catCaramel, Color(hex: "B85F3D")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Capsule())
                                .shadow(color: Color.catCaramel.opacity(0.35), radius: 8, x: 0, y: 4)
                            }
                        } else if isImageLoadFailed {
                            Button {
                                retryImageLoad()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 15, weight: .bold))
                                    Text("圖片載入失敗・點擊重試")
                                        .font(.huninn(size: 16))
                                }
                                .foregroundColor(.catCaramel)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.catCardBackground)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(Color.catCaramel.opacity(0.6), lineWidth: 1.5)
                                )
                                .shadow(color: Color.catCaramel.opacity(0.12), radius: 6, x: 0, y: 3)
                            }
                            .buttonStyle(.plain)
                        } else if isRenderFailed {
                            Button {
                                retryRenderImage()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 15, weight: .bold))
                                    Text("分享圖片產生失敗・點擊重試")
                                        .font(.huninn(size: 16))
                                }
                                .foregroundColor(.catCaramel)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.catCardBackground)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(Color.catCaramel.opacity(0.6), lineWidth: 1.5)
                                )
                                .shadow(color: Color.catCaramel.opacity(0.12), radius: 6, x: 0, y: 3)
                            }
                            .buttonStyle(.plain)
                        } else {
                            Button {
                                // 圖片渲染中，按鈕暫時停用
                            } label: {
                                HStack(spacing: 8) {
                                    ProgressView()
                                        .scaleEffect(0.85)
                                        .tint(.catSecondaryBrown)
                                    Text("分享圖片準備中…")
                                        .font(.huninn(size: 16))
                                }
                                .foregroundColor(.catSecondaryBrown)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
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
                        
                        // 2. 再抽一張喵籤按鈕
                        Button {
                            redrawCard()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 16, weight: .bold))
                                    .rotationEffect(.degrees(isRedrawing ? 360 : 0))
                                Text("再抽一張喵籤")
                                    .font(.huninn(size: 16))
                            }
                            .foregroundColor(.catDarkBrown)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.catCardBackground)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(Color.catCardBorder, lineWidth: 1.5)
                            )
                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                        }
                        .disabled(isRedrawing)
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 32)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                Spacer(minLength: 20)
            }
        }
        .background(Color.catBackground.ignoresSafeArea())
        .navigationTitle("抽籤結果")
        .inlineNavigationBarTitle()
        .task {
            // 將初次抽到的籤卡加入歷史清單
            appendCurrentCardToHistory()
            
            // 同步啟動貓咪圖片載入與本機快取
            let targetCard = currentCard
            imageLoadTask?.cancel()
            imageLoadTask = Task {
                await loadCardImage(for: targetCard)
            }
            
            // 進入頁面延遲 0.35 秒自動翻牌（若被取消則退出，不吞掉 CancellationError）
            do {
                try await Task.sleep(nanoseconds: 350_000_000)
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            
            withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
                isFlipped = true
            }
            HapticManager.success()
        }
        .onDisappear {
            imageLoadTask?.cancel()
            redrawTask?.cancel()
        }
    }
    
    // MARK: - 圖片載入邏輯
    @MainActor
    private func loadCardImage(for targetCard: FortuneCard) async {
        let targetId = targetCard.id
        isImageLoading = true
        isImageLoadFailed = false
        defer {
            isImageLoading = false
        }
        
        #if canImport(UIKit)
        if let (image, fileName) = await FortuneImageManager.shared.getOrDownloadImage(for: targetCard) {
            // 下載完成後先確認未取消且目前卡片仍是同一張，避免連續抽籤時覆蓋新卡片的資料
            guard !Task.isCancelled, currentCard.id == targetId else { return }
            self.cardImage = image
            self.currentCard.localImageFileName = fileName
            self.isImageLoadFailed = false
            self.updateCurrentCardInHistory()
            self.renderCardImage()
        } else {
            guard !Task.isCancelled, currentCard.id == targetId else { return }
            self.isImageLoadFailed = true
            // 下載失敗時不呼叫 renderCardImage()，只有拿到真正的 UIImage 才允許產生分享圖片
        }
        #else
        guard !Task.isCancelled, currentCard.id == targetId else { return }
        self.isImageLoadFailed = true
        #endif
    }
    
    // MARK: - 重試圖片載入
    private func retryImageLoad() {
        guard !isImageLoading else { return }
        HapticManager.light()
        imageLoadTask?.cancel()
        imageLoadTask = Task {
            await loadCardImage(for: currentCard)
        }
    }
    
    // MARK: - 重試分享圖片產生
    private func retryRenderImage() {
        HapticManager.light()
        renderCardImage()
    }
    
    // MARK: - 重新抽籤邏輯
    private func redrawCard() {
        guard !isRedrawing else { return }
        isRedrawing = true
        HapticManager.medium()
        
        // 1. 卡片優雅翻回背面
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            isFlipped = false
        }
        
        redrawTask?.cancel()
        redrawTask = Task {
            // 等待翻回背面動畫
            do {
                try await Task.sleep(nanoseconds: 400_000_000)
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            
            // 2. 重新抽取新卡片並記錄
            let newCard = FortuneData.randomCard(for: initialCategory)
            currentCard = newCard
            #if canImport(UIKit)
            cardImage = nil
            #endif
            renderedShareImage = nil
            isImageLoadFailed = false
            isRenderFailed = false
            appendCurrentCardToHistory()
            
            // 啟動圖片下載與快取（取消前一次未完成的載入任務）
            imageLoadTask?.cancel()
            imageLoadTask = Task {
                await loadCardImage(for: newCard)
            }
            
            do {
                try await Task.sleep(nanoseconds: 200_000_000)
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            
            // 3. 再次翻開卡片
            withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
                isFlipped = true
                isRedrawing = false
            }
            HapticManager.success()
        }
    }
    
    // MARK: - 收藏切換
    private func toggleFavorite() {
        currentCard.isFavorite.toggle()
        updateCurrentCardInHistory()
    }
    
    // MARK: - 加入歷史紀錄
    private func appendCurrentCardToHistory() {
        if !history.contains(where: { $0.id == currentCard.id }) {
            history.insert(currentCard, at: 0)
        }
    }
    
    // MARK: - 更新歷史紀錄中當前卡片資訊（如本地檔名或收藏狀態）
    private func updateCurrentCardInHistory() {
        if let idx = history.firstIndex(where: { $0.id == currentCard.id }) {
            history[idx] = currentCard
        }
    }
    
    // MARK: - 卡片截圖渲染
    @MainActor
    private func renderCardImage() {
        #if canImport(UIKit)
        guard let cardImage = cardImage else { return }
        isRenderFailed = false
        let exportView = FortuneCardFrontView(
            card: currentCard,
            preloadedImage: cardImage,
            allowsNetworkLoading: false,
            onToggleFavorite: nil
        )
        .frame(width: 330, height: 520)
        
        let renderer = ImageRenderer(content: exportView)
        renderer.scale = 3.0
        if let uiImage = renderer.uiImage {
            self.renderedShareImage = Image(uiImage: uiImage)
            self.isRenderFailed = false
        } else {
            self.renderedShareImage = nil
            self.isRenderFailed = true
        }
        #elseif canImport(AppKit)
        isRenderFailed = false
        let exportView = FortuneCardFrontView(
            card: currentCard,
            allowsNetworkLoading: false,
            onToggleFavorite: nil
        )
        .frame(width: 330, height: 520)
        
        let renderer = ImageRenderer(content: exportView)
        renderer.scale = 3.0
        if let nsImage = renderer.nsImage {
            self.renderedShareImage = Image(nsImage: nsImage)
            self.isRenderFailed = false
        } else {
            self.renderedShareImage = nil
            self.isRenderFailed = true
        }
        #endif
    }
}
