# 喵運籤 (Meow Fortune) 🐾

一款以日系和風與療癒貓咪為主題的 iOS 運勢占卜與拍立得籤卡應用程式。每日一抽，讓神秘的「喵神社」為你指引日常吉凶宜忌，搭配真實貓咪照片與精緻 3D 翻牌互動，陪伴你的每一天！

---

## ✨ 核心特色

- ⛩️ **日系和風溫潤視覺**：採用和風紙紋、焦糖棕與金色調設計，搭配圓潤的開源「粉圓字體」（jf-openhuninn），營造溫暖放鬆的御神籤體驗。
- 🐾 **多感官互動體驗**：
  - 主頁呼吸光暈與水波漣漪擴散特效。
  - 摸摸貓爪即時按壓回饋與隨機散落噴發粒子（🐾、✨、💖、🌸、⭐、🐟）。
  - **摸爪彩蛋與音效**：每累計摸爪 5 次，觸發真實貓咪發出呼嚕嚕音效（`SoundManager` + `AVAudioPlayer`）、浮動橫幅提示（Toast）、額外噴發金色星星雨與成功震動回饋！
  - 細緻的觸覺震動體驗（採用 `UIImpactFeedbackGenerator`、`UINotificationFeedbackGenerator` 與 `UISelectionFeedbackGenerator`，並支援 macOS `NSHapticFeedbackManager`）。
- 🎴 **擬真 3D 拍立得抽籤卡**：
  - 流暢的 3D 翻牌動畫與金箔背紋御守設計。
  - 多維度運勢資訊：4 種稀有度等級（SSR 特大吉、大吉喵、中吉喵、小吉喵）、5 大祈願專屬分類、幸運色、防偽印記爪印編號認證與「今日宜／忌」幽默貓咪語錄。
- 📸 **真實貓咪照片與本機持久化**：
  - 整合即時貓咪圖庫（Cataas API），每張籤卡均擁有一張專屬的喵咪拍立得相片。
  - **雙層式快取架構**：記憶體 `NSCache` 高速快取 + App 沙盒文件目錄（`.documentDirectory/FortuneImages`）持久化儲存，已抽取的卡片在離線環境下依然可隨時瀏覽。
  - **安全非同步機制**：精確追蹤 Task 與卡片 ID，防範快速連續抽籤導致圖片與資料錯配，並杜絕重複網路下載。
- 📤 **高清圖文卡片分享**：
  - 運用 SwiftUI `ImageRenderer` 動態合成 3x 高解析度拍立得分享卡。
  - 整合系統 `ShareLink`，一鍵分享至社群平台、通訊軟體或儲存至相簿，並具備圖片準備中停用與產生失敗重試防護。
- 📜 **籤卡歷史回顧與收藏**：
  - 自動記錄歷史抽取的運勢卡（`UserDefaults` 持久化），支援依分類水平滑動篩選與愛心收藏標記。
  - 提供左滑刪除與詳情頁確認刪除，安全連動清除本機快取圖片檔案。

---

## 🛠️ 技術架構

| 項目 | 技術規格 |
| :--- | :--- |
| **開發平台** | iOS 17.0+ / macOS 14.0+ (Designed for iPad / Mac Catalyst 相容) |
| **開發語言** | Swift 5.9+ / Swift Concurrency (async/await, Task, @MainActor) |
| **UI 框架** | SwiftUI |
| **音訊管理** | `AVAudioPlayer` + `AVAudioSession` (`.ambient` 模式，支援背景音樂混合播放) |
| **圖片管理** | `URLSession` + `NSCache` + 本機沙盒檔案系統（`.documentDirectory`） |
| **截圖渲染** | `ImageRenderer` (支援 UIKit / AppKit 條件編譯相容) |
| **資料持久化** | `UserDefaults` (JSON 編解碼) + Document 沙盒磁碟儲存 (`FortuneImages/`) |
| **觸覺回饋** | `UIFeedbackGenerator` (Impact / Notification / Selection) + `NSHapticFeedbackManager` |
| **自訂字型** | jf-openhuninn-2.1 (jf 粉圓字體) |

---

## 📂 專案架構

```text
meow/
├── MyApp.swift                      # 應用程式入口點
├── ContentView.swift                # 主容器、歷史紀錄持久化管理
├── cat_purr.wav                     # 貓咪呼嚕嚕真實音效資源
├── jf-openhuninn-2.1.ttf            # 自訂日系粉圓字型
├── Models/
│   ├── FortuneModels.swift          # 籤卡核心模型 (FortuneCard, FortuneCategory, FortuneRarity)
│   └── FortuneData.swift            # 籤詩資料庫與隨機抽籤邏輯 (含稀有度權重分配)
├── Utilities/
│   ├── Theme.swift                  # 主題配色、自訂字型 (huninn) 擴充
│   ├── SoundManager.swift           # 音訊播放單例 (貓咪呼嚕音效管理)
│   ├── HapticManager.swift          # 系統觸覺回饋封裝 (跨平台支援)
│   └── FortuneImageManager.swift    # 圖片雙層快取與沙盒儲存單例
└── Views/
    ├── HomeView.swift               # 首頁：類別選擇、動態貓爪微互動與彩蛋 Toast / 呼嚕音效
    ├── ResultView.swift             # 抽籤結果：3D 翻牌、圖片下載、高解析渲染與分享
    ├── CardDetailView.swift         # 歷史籤卡詳情：卡片檢視、載入重試、刪除確認
    ├── HistoryView.swift            # 歷史紀錄列表：分類過濾、收藏切換、滑動刪除
    └── Components/
        ├── FortuneCardFrontView.swift # 拍立得正面元件 (離線佔位/防重複下載)
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

### 祈願類別 (`FortuneCategory`)
| 類別名稱 | 系統圖示 | 說明 |
| :--- | :--- | :--- |
| **全部** | `sparkles` | 檢視所有祈願類別運勢 |
| **綜合喵運** | `cat.fill` | 全方位的喵生指引與日常運程 |
| **財富喵運** | `fish.fill` | 滿滿罐罐、財運亨通與收穫指南 |
| **戀愛喵運** | `heart.fill` | 人際牽絆、好感增溫與情感建議 |
| **事業喵運** | `briefcase.fill` | 工作喵躍、靈感噴發與專案順利 |
| **平安喵運** | `shield.fill` | 諸事平安、心境沉穩與療癒指引 |

### 稀有度等級 (`FortuneRarity`)
| 稀有度 | 抽取權重 | 代表幸運色 | 籤卡徽章視覺 |
| :--- | :---: | :--- | :--- |
| **SSR 特大吉** | 8% | 流金金橘 (`#E09736`) | 璀璨金底與專屬高光 |
| **大吉喵** | 22% | 焦糖朱紅 (`#D15B47`) | 喜氣和風朱紅標籤 |
| **中吉喵** | 35% | 暖蜜杏黃 (`#DB9E3E`) | 溫潤明亮杏黃標籤 |
| **小吉喵** | 35% | 抹茶焙青 (`#6A9362`) | 清雅寧靜焙茶綠標籤 |

---

## 📄 授權條款 (License)

本專案採用 [MIT License](LICENSE) 授權。
所附之自訂字體 **jf-openhuninn**（粉圓字體）遵循由 justfont 發布之 [SIL Open Font License 1.1](https://github.com/justfont/open-huninn-font) 條款。
