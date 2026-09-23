# 喵運籤 (Meow Fortune) 🐾

一款以日系和風與療癒貓咪為主題的 iOS 運勢占卜與拍立得籤卡應用程式。每日一抽，讓神秘的「喵神社」為你指引日常吉凶宜忌，搭配真實貓咪照片與精緻 3D 翻牌互動，陪伴你的每一天！

---

## ✨ 核心特色

- ⛩️ **日系和風溫潤視覺**：採用和風紙紋、焦糖棕與金色調設計，搭配圓潤的開源「粉圓字體」（jf-openhuninn），營造溫暖放鬆的御神籤體驗。
- 🐾 **多感官互動體驗**：
  - 主頁呼吸光暈與水波漣漪特效。
  - 摸摸貓爪互動回饋與歡樂噴發粒子。
  - 隱藏彩蛋：連續摸摸貓爪觸發喵咪呼嚕聲與幸運加倍祝福！
  - 結合細緻的觸覺震動回饋（CoreHaptics / UIImpactFeedbackGenerator）。
- 🎴 **擬真 3D 拍立得抽籤卡**：
  - 流暢的 3D 翻牌動畫與金箔背紋御守設計。
  - 多維度運勢資訊：稀有度（大吉、中吉、小吉、特吉、貓神吉）、七大祈願分類、專屬幸運色、爪印編號認證與「今日宜／忌」幽默貓咪語錄。
- 📸 **真實貓咪照片與離線快取**：
  - 整合即時貓咪圖庫，每張籤卡均有一張專屬的喵咪拍立得相片。
  - **二層式快取系統**：內建記憶體 `NSCache` 與本機沙盒磁碟儲存，抽取過的卡片在無網路環境下也能隨時翻閱。
  - **智慧並行下載機制**：預防快速連續抽籤造成的圖片錯配，並杜絕重複網路下載。
- 📤 **高清圖文卡片分享**：
  - 運用 SwiftUI `ImageRenderer` 動態合成 3x 高解析度拍立得分享卡。
  - 整合系統 `ShareLink`，一鍵分享至 Instagram、LINE、訊息或儲存到相簿。
- 📜 **籤卡歷史回顧與收藏**：
  - 自動記錄歷史抽取的運勢卡，支援依分類快速篩選與愛心收藏標記。
  - 提供滑動刪除功能，並安全聯動本機快取圖檔清理。

---

## 🛠️ 技術架構

| 項目 | 技術規格 |
| :--- | :--- |
| **開發平台** | iOS 17.0+ / macOS (Designed for iPad/Mac Catalyst) |
| **開發語言** | Swift 5.9+ / Swift Concurrency (async/await, Task, Actor-safe) |
| **UI 框架** | SwiftUI |
| **圖片管理** | `URLSession` + `NSCache` + App Sandbox FileManager |
| **截圖渲染** | `ImageRenderer` (支援 UIKit / AppKit 跨平台相容編譯) |
| **資料持久化** | `UserDefaults` (JSON 序列化儲存) + 沙盒磁碟儲存 (CachesDirectory) |
| **自訂字型** | jf-openhuninn-2.1 (jf 粉圓字體) |

---

## 📂 專案架構

```text
meow/
├── MyApp.swift                      # 應用程式入口點
├── ContentView.swift                # 主容器、歷史紀錄持久化管理
├── Models/
│   ├── FortuneModels.swift          # 籤卡核心模型 (FortuneCard, Category, Rarity, Advice)
│   └── FortuneData.swift            # 籤詩資料庫與隨機抽籤邏輯
├── Utilities/
│   ├── Theme.swift                  # 主題配色、自訂字型 (huninn) 擴充
│   ├── HapticManager.swift          # 系統觸覺回饋封裝
│   └── FortuneImageManager.swift    # 圖片雙層快取與磁碟管理單例
└── Views/
    ├── HomeView.swift               # 首頁：分類選擇、動態貓爪互動與彩蛋系統
    ├── ResultView.swift             # 抽籤結果：3D 翻牌、圖片下載、高解析分享
    ├── CardDetailView.swift         # 歷史籤卡詳情：全卡檢視、重試機制、刪除確認
    ├── HistoryView.swift            # 歷史紀錄列表：分類過濾、收藏切換、卡片預覽
    └── Components/
        ├── FortuneCardFrontView.swift # 拍立得正面元件 (支援離線/防重複載入)
        └── FortuneCardBackView.swift  # 和風金紋御守背面元件
```

---

## 🚀 開始使用

### 需求條件
- Xcode 15.0 以上
- iOS 17.0 以上模擬器或實體裝置
- macOS Sonoma (14.0) 以上

### 安裝與執行
1. 複製專案至本機：
   ```bash
   git clone https://github.com/meatmeateater/meow_draw.git
   cd meow_draw
   ```
2. 使用 Xcode 打開專案：
   ```bash
   open meow.xcodeproj
   ```
3. 選擇欲運行的目標裝置（例如 `iPhone 16 Pro`）。
4. 按下 `Cmd + R` 即可編譯並執行。

---

## 🐾 分類與稀有度一覽

### 祈願分類
- 🌟 **綜合運勢**：全方位的喵生指引
- 💕 **戀愛貓緣**：人際與情感昇華
- 💼 **事業喵躍**：工作效率與升遷靈感
- 💰 **財富罐罐**：滿滿罐罐、財運亨通
- 🧘 **身心舒壓**：放慢步調、曬曬太陽
- 🤝 **人際社交**：呼嚕嚕好人緣

### 稀有度等級
- 🐾 **大吉** (SSR)
- 🌸 **中吉** (SR)
- 🌿 **小吉** (R)
- ✨ **特吉** (UR)
- 👑 **貓神吉** (SP)

---

## 📄 授權條款 (License)

本專案採用 [MIT License](LICENSE) 授權。
所附之自訂字體 **jf-openhuninn**（粉圓字體）遵循由 justfont 發布之 [SIL Open Font License 1.1](https://github.com/justfont/open-huninn-font) 條款。
