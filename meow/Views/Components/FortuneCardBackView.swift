import SwiftUI

// MARK: - 喵運御守卡牌背面（日式神社御守風）
struct FortuneCardBackView: View {
    var body: some View {
        ZStack {
            // 底色：溫潤米白搭配和風微漸層
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "FDFBF7"),
                            Color(hex: "F7F1E6"),
                            Color(hex: "F0E4D4")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // 外層細金線邊框
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.catGold.opacity(0.8), Color.catCaramel.opacity(0.6), Color.catGold.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .padding(12)
            
            // 內層虛線細金線邊框
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    Color.catGold.opacity(0.45),
                    style: StrokeStyle(lineWidth: 1, dash: [5, 4])
                )
                .padding(18)
            
            // 四個角落和風幾何角花飾
            VStack {
                HStack {
                    CornerOrnament()
                    Spacer()
                    CornerOrnament()
                        .rotationEffect(.degrees(90))
                }
                Spacer()
                HStack {
                    CornerOrnament()
                        .rotationEffect(.degrees(270))
                    Spacer()
                    CornerOrnament()
                        .rotationEffect(.degrees(180))
                }
            }
            .padding(26)
            
            // 中央主要御守紋章與標題
            VStack(spacing: 20) {
                // 頂部日式結繩象徵圖案
                HStack(spacing: 8) {
                    Image(systemName: "sparkle")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.catGold)
                    Text("奉 納 · 心 願 成 就")
                        .font(.huninn(size: 11))
                        .tracking(3)
                        .foregroundColor(.catSecondaryBrown)
                    Image(systemName: "sparkle")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.catGold)
                }
                .padding(.top, 10)
                
                Spacer()
                
                // 金色貓爪御神印徽章
                ZStack {
                    // 同心圓光暈
                    Circle()
                        .stroke(Color.catGold.opacity(0.25), lineWidth: 1)
                        .frame(width: 140, height: 140)
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.catGold.opacity(0.6), Color.catCaramel.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 2, dash: [4, 3])
                        )
                        .frame(width: 124, height: 124)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color.white, Color(hex: "FBF3E8")]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 50
                            )
                        )
                        .frame(width: 104, height: 104)
                        .shadow(color: Color.catCaramel.opacity(0.12), radius: 8, x: 0, y: 4)
                    
                    // 金色貓爪本體
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "E8AA42"), Color.catCaramel],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color.catCaramel.opacity(0.25), radius: 3, x: 0, y: 2)
                }
                
                // 御守主文字
                VStack(spacing: 8) {
                    Text("喵 運 御 守")
                        .font(.huninn(size: 26))
                        .tracking(6)
                        .foregroundColor(.catDarkBrown)
                    
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(Color.catGold.opacity(0.5))
                            .frame(width: 24, height: 1)
                        
                        Text("CAT FORTUNE")
                            .font(.huninn(size: 12))
                            .tracking(4)
                            .foregroundColor(.catCaramel)
                        
                        Rectangle()
                            .fill(Color.catGold.opacity(0.5))
                            .frame(width: 24, height: 1)
                    }
                }
                
                Spacer()
                
                // 底部印章感祈福文字
                VStack(spacing: 4) {
                    Text("諸事吉利 · 喵爪印證")
                        .font(.huninn(size: 11))
                        .tracking(2)
                        .foregroundColor(.catSecondaryBrown)
                    Text("NO. 8888 · LUCKY AMULET")
                        .font(.huninn(size: 9))
                        .foregroundColor(.catMutedBrown)
                }
                .padding(.bottom, 12)
            }
            .padding(32)
        }
        .frame(width: 330, height: 520)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
        .shadow(color: Color.catCaramel.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

// 角落幾何和風裝飾圖示
private struct CornerOrnament: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 14))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 14, y: 0))
        }
        .stroke(Color.catGold.opacity(0.7), lineWidth: 1.5)
        .frame(width: 14, height: 14)
    }
}

#Preview {
    FortuneCardBackView()
        .padding()
        .background(Color.catBackground)
}
