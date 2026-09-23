import SwiftUI

// MARK: - 主視圖與歷史資料持久化管理
struct ContentView: View {
    @State private var history: [FortuneCard] = []
    
    private let historyStorageKey = "cat_fortune_history_storage_key"
    
    var body: some View {
        HomeView(history: $history)
            .font(.huninn(size: 15))
            .onAppear {
                loadHistory()
            }
            .onChange(of: history) {
                saveHistory()
            }
    }
    
    // MARK: - 從 UserDefaults 載入歷史
    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyStorageKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([FortuneCard].self, from: data)
            self.history = decoded
        } catch {
            print("Failed to decode fortune history: \(error)")
        }
    }
    
    // MARK: - 儲存歷史至 UserDefaults
    private func saveHistory() {
        do {
            let encoded = try JSONEncoder().encode(history)
            UserDefaults.standard.set(encoded, forKey: historyStorageKey)
        } catch {
            print("Failed to encode fortune history: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
