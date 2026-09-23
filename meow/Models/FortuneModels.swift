import SwiftUI

// MARK: - 運勢類別
enum FortuneCategory: String, CaseIterable, Identifiable, Codable, Hashable {
    case all = "全部"
    case general = "綜合喵運"
    case wealth = "財富喵運"
    case love = "戀愛喵運"
    case career = "事業喵運"
    case peace = "平安喵運"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var iconName: String {
        switch self {
        case .all:
            return "sparkles"
        case .general:
            return "cat.fill"
        case .wealth:
            return "fish.fill"
        case .love:
            return "heart.fill"
        case .career:
            return "briefcase.fill"
        case .peace:
            return "shield.fill"
        }
    }
}

// MARK: - 稀有度
enum FortuneRarity: String, CaseIterable, Identifiable, Codable, Hashable {
    case ssr = "SSR 特大吉"
    case daikichi = "大吉喵"
    case chukichi = "中吉喵"
    case shokichi = "小吉喵"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var colorName: String {
        switch self {
        case .ssr:
            return "流金金橘"
        case .daikichi:
            return "焦糖朱紅"
        case .chukichi:
            return "暖蜜杏黃"
        case .shokichi:
            return "抹茶焙青"
        }
    }
    
    var badgeColor: Color {
        switch self {
        case .ssr:
            return Color(hex: "E09736")
        case .daikichi:
            return Color(hex: "D15B47")
        case .chukichi:
            return Color(hex: "DB9E3E")
        case .shokichi:
            return Color(hex: "6A9362")
        }
    }
    
    var badgeBackgroundColor: Color {
        switch self {
        case .ssr:
            return Color(hex: "FFF7EB")
        case .daikichi:
            return Color(hex: "FCEEED")
        case .chukichi:
            return Color(hex: "FFF8EC")
        case .shokichi:
            return Color(hex: "EFF7EE")
        }
    }
}

// MARK: - 籤卡資料模型
struct FortuneCard: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var title: String
    var advice: String
    var luckyColor: String
    var category: FortuneCategory
    var rarity: FortuneRarity
    var imageURLString: String
    var isFavorite: Bool = false
    var timestamp: Date = Date()
    
    // 宜／忌拆分輔助
    var parsedAdvice: (good: String, bad: String) {
        // 格式通常為「宜：...；忌：...」
        let parts = advice.components(separatedBy: "；")
        var good = ""
        var bad = ""
        for part in parts {
            let trimmed = part.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.hasPrefix("宜：") {
                good = String(trimmed.dropFirst(2))
            } else if trimmed.hasPrefix("忌：") {
                bad = String(trimmed.dropFirst(2))
            }
        }
        if good.isEmpty && bad.isEmpty {
            return (good: advice, bad: "")
        }
        return (good: good, bad: bad)
    }
}
