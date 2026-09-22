import SwiftUI

// MARK: - 歷史紀錄與收藏列表
struct HistoryView: View {
    @Binding var history: [FortuneCard]
    
    @State private var showFavoritesOnly = false
    @State private var selectedCategory: FortuneCategory = .all
    @State private var showClearConfirm = false
    @State private var selectedCardId: UUID? = nil
    
    private var favoriteCount: Int {
        history.filter { $0.isFavorite }.count
    }
    
    private var filteredHistory: [FortuneCard] {
        history.filter { card in
            let matchesFavorite = !showFavoritesOnly || card.isFavorite
            let matchesCategory = selectedCategory == .all || card.category == selectedCategory
            return matchesFavorite && matchesCategory
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 頂部篩選器
            VStack(spacing: 12) {
                // 全部紀錄 / 只看收藏 膠囊分段切換
                HStack(spacing: 8) {
                    filterTabButton(title: "全部紀錄 (\(history.count))", isSelected: !showFavoritesOnly) {
                        showFavoritesOnly = false
                    }
                    
                    filterTabButton(title: "我的收藏 (\(favoriteCount))", isSelected: showFavoritesOnly) {
                        showFavoritesOnly = true
                    }
                }
                .padding(.horizontal, 16)
                
                // 類別橫向滾動膠囊列
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(FortuneCategory.allCases) { category in
                            Button {
                                HapticManager.selection()
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCategory = category
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: category.iconName)
                                        .font(.system(size: 11, weight: .bold))
                                    Text(category.title)
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .foregroundColor(selectedCategory == category ? .white : .catSecondaryBrown)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(
                                    selectedCategory == category
                                        ? Color.catCaramel
                                        : Color.catCardBackground
                                )
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(
                                            selectedCategory == category ? Color.clear : Color.catCardBorder,
                                            lineWidth: 1
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 12)
            .background(Color.catBackground)
            
            Divider()
                .overlay(Color.catCardBorder.opacity(0.5))
            
            // MARK: - 列表主體或空狀態
            if filteredHistory.isEmpty {
                emptyStateView
            } else {
                List {
                    ForEach(filteredHistory) { card in
                        if let index = history.firstIndex(where: { $0.id == card.id }) {
                            NavigationLink {
                                CardDetailView(
                                    card: $history[index],
                                    onToggleFavorite: {
                                        history[index].isFavorite.toggle()
                                    },
                                    onDelete: {
                                        history.remove(at: index)
                                    }
                                )
                            } label: {
                                historyRow(card: card, index: index)
                            }
                            .listRowBackground(Color.catCardBackground)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparatorTint(Color.catCardBorder.opacity(0.6))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .scrollContentBackground(.hidden)
                .background(Color.catBackground)
                .listStyle(.plain)
            }
        }
        .background(Color.catBackground.ignoresSafeArea())
        .navigationTitle("喵運歷史")
        .inlineNavigationBarTitle()
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                if !history.isEmpty {
                    Button(role: .destructive) {
                        showClearConfirm = true
                    } label: {
                        Text("清空")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.catBadRed)
                    }
                }
            }
        }
        .confirmationDialog("確定要清空所有喵籤歷史嗎？", isPresented: $showClearConfirm, titleVisibility: .visible) {
            Button("清空全部歷史", role: .destructive) {
                HapticManager.heavy()
                withAnimation {
                    history.removeAll()
                }
            }
            Button("取消", role: .cancel) {}
        }
    }
    
    // MARK: - 篩選分頁按鈕
    private func filterTabButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            HapticManager.selection()
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? Color.catDarkBrown : Color.catSecondaryBrown)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(isSelected ? Color.catCardBackground : Color.clear)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? Color.catCaramel.opacity(0.4) : Color.clear, lineWidth: 1)
                )
                .shadow(color: isSelected ? Color.black.opacity(0.04) : Color.clear, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .padding(3)
        .background(Color(hex: "EDE6DA"))
        .clipShape(Capsule())
    }
    
    // MARK: - 卡片列表單列視圖
    private func historyRow(card: FortuneCard, index: Int) -> some View {
        HStack(spacing: 12) {
            // 縮圖
            AsyncImage(url: URL(string: card.imageURLString)) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "F2EAE0"))
                        .overlay(ProgressView().scaleEffect(0.7).tint(.catCaramel))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                default:
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "F2EAE0"))
                        .overlay(
                            Image(systemName: "cat.fill")
                                .foregroundColor(.catCaramel)
                        )
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.catCardBorder, lineWidth: 1)
            )
            
            // 資訊
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(card.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.catDarkBrown)
                        .lineLimit(1)
                    
                    Text(card.rarity.title)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(card.rarity.badgeColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(card.rarity.badgeBackgroundColor)
                        .clipShape(Capsule())
                }
                
                HStack(spacing: 8) {
                    Text(card.category.title)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.catCaramel)
                    
                    Text("•")
                        .foregroundColor(.catMutedBrown)
                    
                    Text(card.timestamp, style: .date)
                        .font(.system(size: 11))
                        .foregroundColor(.catMutedBrown)
                }
                
                Text(card.advice)
                    .font(.system(size: 11))
                    .foregroundColor(.catSecondaryBrown)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // 收藏獨立切換按鈕
            Button {
                HapticManager.light()
                history[index].isFavorite.toggle()
            } label: {
                Image(systemName: card.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(card.isFavorite ? Color(hex: "E64A4A") : Color.catMutedBrown)
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - 空狀態視圖
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(hex: "F4EDE2"))
                    .frame(width: 90, height: 90)
                
                Image(systemName: showFavoritesOnly ? "heart.slash.fill" : "cat.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.catCaramel.opacity(0.85))
            }
            
            VStack(spacing: 6) {
                Text(showFavoritesOnly ? "尚無收藏的喵籤" : "尚無喵運紀錄")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.catDarkBrown)
                
                Text(showFavoritesOnly ? "點擊籤卡上的愛心，即可將喜愛的喵運收藏於此 💖" : "快去首頁摸摸貓爪，抽取今日專屬喵運吧 🐾")
                    .font(.system(size: 13))
                    .foregroundColor(.catSecondaryBrown)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    // MARK: - 滑動刪除
    private func deleteItems(at offsets: IndexSet) {
        HapticManager.light()
        let itemsToDelete = offsets.map { filteredHistory[$0] }
        history.removeAll { card in
            itemsToDelete.contains { $0.id == card.id }
        }
    }
}
