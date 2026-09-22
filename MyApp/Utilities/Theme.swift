import SwiftUI

// MARK: - App Color & Visual Design System
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // 日系溫潤米杏色主調
    static let catBackground = Color(hex: "FAF7F0")
    static let catCardBackground = Color.white
    static let catCardBorder = Color(hex: "E8DFD0")
    
    // 暖焦糖橘重點色
    static let catCaramel = Color(hex: "D17A5A")
    static let catGold = Color(hex: "D99B38")
    static let catLightOrange = Color(hex: "F7E7D9")
    
    // 深暖棕字體
    static let catDarkBrown = Color(hex: "3D2C1E")
    static let catSecondaryBrown = Color(hex: "7C6B5E")
    static let catMutedBrown = Color(hex: "A8988B")
    
    // 宜／忌標籤色
    static let catGoodGreen = Color(hex: "5A8A62")
    static let catGoodBg = Color(hex: "EBF2EC")
    static let catBadRed = Color(hex: "C25E4B")
    static let catBadBg = Color(hex: "FCEEEB")
}

// MARK: - Navigation Bar Compatibility
extension View {
    @ViewBuilder
    func inlineNavigationBarTitle() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}
