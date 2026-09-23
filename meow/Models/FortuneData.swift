import Foundation

// MARK: - 內建籤池與生成器
struct FortuneTemplate {
    let title: String
    let advice: String
    let luckyColor: String
    let category: FortuneCategory
    let rarity: FortuneRarity
}

enum FortuneData {
    static let templates: [FortuneTemplate] = [
        // 綜合喵運
        FortuneTemplate(
            title: "罐罐自由喵",
            advice: "宜：盡情享受開罐之音、放肆大呼嚕；忌：半夜發呆憂鬱、為未發生的事煩惱。",
            luckyColor: "琥珀金毛色",
            category: .general,
            rarity: .ssr
        ),
        FortuneTemplate(
            title: "日光浴達人",
            advice: "宜：在窗台追逐午後暖陽、伸懶腰梳毛；忌：把自己憋在陰暗角落胡思亂想。",
            luckyColor: "焦糖烤吐司色",
            category: .general,
            rarity: .daikichi
        ),
        FortuneTemplate(
            title: "慢活佛系喵",
            advice: "宜：按自己的節奏優雅慢步、吃飽即福；忌：跟別人的步伐內卷、盲目焦慮。",
            luckyColor: "奶油燕麥色",
            category: .general,
            rarity: .chukichi
        ),
        FortuneTemplate(
            title: "平凡是福喵",
            advice: "宜：泡一杯熱茶、安靜享受當下的寧靜；忌：太在意旁人眼光、對小事耿耿於懷。",
            luckyColor: "晨霧淺灰白",
            category: .general,
            rarity: .shokichi
        ),
        
        // 財富喵運
        FortuneTemplate(
            title: "小魚乾富翁",
            advice: "宜：存好每日小魚乾、笑納意外驚喜獎賞；忌：盲目衝動下單、被花俏包裝迷惑。",
            luckyColor: "流金三花色",
            category: .wealth,
            rarity: .ssr
        ),
        FortuneTemplate(
            title: "招財肉墊本貓",
            advice: "宜：舉起右手招福納財、對帳單記帳；忌：出門忘帶錢包、錯過限時折扣優惠。",
            luckyColor: "金桔焦糖橘",
            category: .wealth,
            rarity: .daikichi
        ),
        FortuneTemplate(
            title: "點滴聚糧喵",
            advice: "宜：審視日常開銷、把錢花在刀口與喜好上；忌：跟風投資不熟悉的旁門左道。",
            luckyColor: "栗子可可棕",
            category: .wealth,
            rarity: .chukichi
        ),
        FortuneTemplate(
            title: "知足小糧倉",
            advice: "宜：珍惜每一口溫飽、善用身邊已有的資源；忌：大手大腳超額透支。",
            luckyColor: "玄米焙茶綠",
            category: .wealth,
            rarity: .shokichi
        ),
        
        // 戀愛喵運
        FortuneTemplate(
            title: "蹭蹭萬人迷",
            advice: "宜：主動貼貼撒嬌、翻肚肚坦率表達愛意；忌：傲嬌冷戰、伸出爪爪哈氣不講理。",
            luckyColor: "蜜桃粉肉墊色",
            category: .love,
            rarity: .ssr
        ),
        FortuneTemplate(
            title: "心跳呼嚕嚕",
            advice: "宜：傳遞溫柔微笑眼神、分享生活微小趣味；忌：過度腦補揣測、緊迫盯人查勤。",
            luckyColor: "櫻花奶霜粉",
            category: .love,
            rarity: .daikichi
        ),
        FortuneTemplate(
            title: "微甜偶遇喵",
            advice: "宜：保持神祕優雅氣質、從容不迫地互動；忌：急於要確定承諾、患得患失。",
            luckyColor: "乾燥玫瑰紅",
            category: .love,
            rarity: .chukichi
        ),
        FortuneTemplate(
            title: "自愛自得喵",
            advice: "宜：先學會溫柔擁抱自己、給自己買朵花；忌：委屈求全、為了討好迎合他人。",
            luckyColor: "丁香薄霧紫",
            category: .love,
            rarity: .shokichi
        ),
        
        // 事業喵運
        FortuneTemplate(
            title: "霸道喵總裁",
            advice: "宜：果斷踏出堅定爪印、踏平一切困難阻礙；忌：在鍵盤上打瞌睡、拖延關鍵任務。",
            luckyColor: "烏木曜石黑",
            category: .career,
            rarity: .ssr
        ),
        FortuneTemplate(
            title: "精準捕獵喵",
            advice: "宜：鎖定核心目標一擊即中、條理清晰溝通；忌：被無關雜訊逗貓棒分心、粗心大意。",
            luckyColor: "深海星空藍",
            category: .career,
            rarity: .daikichi
        ),
        FortuneTemplate(
            title: "穩健踏步喵",
            advice: "宜：逐一核對清單踏實執行、累積小成就；忌：好高騖遠空想、半途而廢隨意放棄。",
            luckyColor: "摩卡焙茶灰",
            category: .career,
            rarity: .chukichi
        ),
        FortuneTemplate(
            title: "蓄力沉潛喵",
            advice: "宜：多看多學為自己充電、梳理未來規劃；忌：急功近利、因為一時受挫灰心。",
            luckyColor: "冷杉墨石綠",
            category: .career,
            rarity: .shokichi
        ),
        
        // 平安喵運
        FortuneTemplate(
            title: "安睡無憂喵",
            advice: "宜：徹底伸展四肢睡個好覺、定時喝足溫水；忌：在高處危險走鋼索、暴飲暴食吃太急。",
            luckyColor: "棉花羽絨白",
            category: .peace,
            rarity: .ssr
        ),
        FortuneTemplate(
            title: "御守護體喵",
            advice: "宜：早睡早起養精蓄銳、漫步在清爽微風中；忌：通宵熬夜滑手機、情緒大起大落。",
            luckyColor: "翡翠碧玉綠",
            category: .peace,
            rarity: .daikichi
        ),
        FortuneTemplate(
            title: "柔順順毛喵",
            advice: "宜：做做溫和伸展操、保持心情開朗放鬆；忌：久坐蜷縮不動、猛灌冰飲傷脾胃。",
            luckyColor: "薄荷淡青綠",
            category: .peace,
            rarity: .chukichi
        ),
        FortuneTemplate(
            title: "平靜順遂喵",
            advice: "宜：放慢腳步深呼吸、維持規律健康作息；忌：跟無謂的人起爭執、過度耗損精力。",
            luckyColor: "青嵐月白玉",
            category: .peace,
            rarity: .shokichi
        )
    ]
    
    // 生成隨機籤卡
    static func randomCard(for category: FortuneCategory = .all) -> FortuneCard {
        let pool: [FortuneTemplate]
        if category == .all {
            pool = templates
        } else {
            let filtered = templates.filter { $0.category == category }
            pool = filtered.isEmpty ? templates : filtered
        }
        
        let template = pool.randomElement() ?? templates[0]
        
        // 使用 cataas API 搭配 UUID 參數避免重複快取
        let uniqueQuery = UUID().uuidString
        let imageURL = "https://cataas.com/cat?t=\(uniqueQuery)"
        
        return FortuneCard(
            title: template.title,
            advice: template.advice,
            luckyColor: template.luckyColor,
            category: template.category,
            rarity: template.rarity,
            imageURLString: imageURL,
            isFavorite: false,
            timestamp: Date()
        )
    }
}
