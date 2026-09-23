import SwiftUI

// MARK: - 粒子特效資料模型
private struct TapParticle: Identifiable {
    let id = UUID()
    let symbol: String
    var offset: CGSize
    var opacity: Double
    var scale: CGFloat
    var rotation: Double
}

// MARK: - 首頁
struct HomeView: View {
    @Binding var history: [FortuneCard]
    
    @State private var selectedCategory: FortuneCategory = .all
    @State private var pawScale: CGFloat = 1.0
    @State private var isBreathing = false
    @State private var isShockwaveActive = false
    @State private var shockwaveScale: CGFloat = 0.8
    @State private var shockwaveOpacity: Double = 0.0
    
    // 彩蛋與計數
    @State private var tapCount: Int = 0
    @State private var showEasterEggBanner: Bool = false
    @State private var easterEggTimer: Task<Void, Never>? = nil
    
    // 導航控制
    @State private var navigateToResult: Bool = false
    @State private var navigateToHistory: Bool = false
    @State private var navigationTask: Task<Void, Never>? = nil
    
    // 噴發粒子陣列
    @State private var particles: [TapParticle] = []
    
    private let availableParticleSymbols = ["🐾", "✨", "💖", "🌸", "⭐", "🐟"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 日系溫潤背景
                Color.catBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - 頂部類別水平滑動膠囊列
                    categorySelectorBar
                        .padding(.top, 12)
                        .padding(.bottom, 16)
                    
                    Spacer()
                    
                    // MARK: - 中央核心貓爪與互動按鈕區
                    VStack(spacing: 32) {
                        // 導引副標題
                        VStack(spacing: 8) {
                            Text("摸摸貓爪 · 抽今日專屬喵籤")
                                .font(.huninn(size: 20))
                                .foregroundColor(.catDarkBrown)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 12))
                                    .foregroundColor(.catGold)
                                Text("當前祈願類別：\(selectedCategory.title)")
                                    .font(.huninn(size: 13))
                                    .foregroundColor(.catSecondaryBrown)
                                Image(systemName: "sparkles")
                                    .font(.system(size: 12))
                                    .foregroundColor(.catGold)
                            }
                        }
                        
                        // 中央大貓爪互動按鈕本體
                        interactivePawButton
                        
                        // 累計摸摸次數提示
                        HStack(spacing: 6) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.catCaramel)
                            Text("已摸摸貓爪 \(tapCount) 次")
                                .font(.huninn(size: 12))
                                .foregroundColor(.catSecondaryBrown)
                            Text("（每 5 次有呼嚕彩蛋 🐾）")
                                .font(.huninn(size: 11))
                                .foregroundColor(.catMutedBrown)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Color(hex: "EFE5D6"))
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    // MARK: - 底部功能按鈕
                    bottomActionBar
                        .padding(.horizontal, 32)
                        .padding(.bottom, 28)
                }
                
                // MARK: - 彩蛋浮動提示橫幅 (Toast)
                if showEasterEggBanner {
                    VStack {
                        easterEggBannerView
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .padding(.top, 12)
                        Spacer()
                    }
                }
                
                // MARK: - 散落噴發粒子
                ForEach(particles) { particle in
                    Text(particle.symbol)
                        .font(.huninn(size: 20))
                        .scaleEffect(particle.scale)
                        .opacity(particle.opacity)
                        .rotationEffect(.degrees(particle.rotation))
                        .offset(particle.offset)
                        .allowsHitTesting(false)
                }
            }
            .navigationTitle("喵運籤")
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        HapticManager.selection()
                        navigateToHistory = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 14, weight: .semibold))
                            Text("歷史")
                                .font(.huninn(size: 14))
                        }
                        .foregroundColor(.catCaramel)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.catLightOrange.opacity(0.6))
                        .clipShape(Capsule())
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToResult) {
                ResultView(initialCategory: selectedCategory, history: $history)
            }
            .navigationDestination(isPresented: $navigateToHistory) {
                HistoryView(history: $history)
            }
            .onAppear {
                // 啟動環境呼吸光暈動畫
                withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                    isBreathing = true
                }
            }
        }
    }
    
    // MARK: - 類別橫向切換列
    private var categorySelectorBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FortuneCategory.allCases) { category in
                    let isSelected = selectedCategory == category
                    Button {
                        HapticManager.selection()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: category.iconName)
                                .font(.system(size: 13, weight: .bold))
                            Text(category.title)
                                .font(.huninn(size: 13))
                        }
                        .foregroundColor(isSelected ? .white : .catSecondaryBrown)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            isSelected
                                ? LinearGradient(
                                    colors: [Color.catCaramel, Color(hex: "BF6748")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    colors: [Color.catCardBackground, Color(hex: "F8F2E8")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(isSelected ? Color.clear : Color.catCardBorder, lineWidth: 1)
                        )
                        .shadow(
                            color: isSelected ? Color.catCaramel.opacity(0.3) : Color.black.opacity(0.03),
                            radius: isSelected ? 6 : 2,
                            x: 0,
                            y: isSelected ? 3 : 1
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - 核心多重互動動畫貓爪按鈕
    private var interactivePawButton: some View {
        ZStack {
            // 1. 呼吸擴散水波紋光圈 1
            Circle()
                .stroke(Color.catCaramel.opacity(isBreathing ? 0.08 : 0.22), lineWidth: 2)
                .frame(width: 260, height: 260)
                .scaleEffect(isBreathing ? 1.15 : 0.95)
            
            // 2. 呼吸擴散水波紋光圈 2
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.catGold.opacity(0.3), Color.catCaramel.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                )
                .frame(width: 230, height: 230)
                .rotationEffect(.degrees(isBreathing ? 180 : 0))
            
            // 3. 點擊瞬間衝擊波（Shockwave）
            Circle()
                .stroke(Color.catCaramel.opacity(shockwaveOpacity), lineWidth: 3)
                .frame(width: 200, height: 200)
                .scaleEffect(shockwaveScale)
            
            // 4. 外層柔和發光背景底盤
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color(hex: "FDF8F0"),
                            Color(hex: "F7ECE0")
                        ]),
                        center: .center,
                        startRadius: 10,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
                .shadow(
                    color: Color.catCaramel.opacity(isBreathing ? 0.25 : 0.12),
                    radius: isBreathing ? 24 : 14,
                    x: 0,
                    y: 8
                )
                .overlay(
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.catGold.opacity(0.6), Color.catCaramel.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                )
            
            // 5. 四顆環境環繞微光裝飾星星
            ambientSparkles
            
            // 6. 貓爪本體（點擊觸發縮放與粒子）
            VStack(spacing: 8) {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 78))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "E89369"), Color.catCaramel, Color(hex: "B75936")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.catCaramel.opacity(0.35), radius: 6, x: 0, y: 4)
                
                Text("TAP ME")
                    .font(.huninn(size: 11))
                    .tracking(2)
                    .foregroundColor(.catCaramel.opacity(0.9))
            }
            .scaleEffect(pawScale)
        }
        .contentShape(Circle())
        .onTapGesture {
            handlePawTap()
        }
    }
    
    // MARK: - 環境微光星星
    private var ambientSparkles: some View {
        ZStack {
            Image(systemName: "sparkle")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.catGold)
                .offset(x: -75, y: -65)
                .opacity(isBreathing ? 0.9 : 0.4)
                .scaleEffect(isBreathing ? 1.1 : 0.8)
            
            Image(systemName: "sparkle")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.catCaramel)
                .offset(x: 75, y: -55)
                .opacity(isBreathing ? 0.4 : 0.85)
                .scaleEffect(isBreathing ? 0.8 : 1.15)
            
            Image(systemName: "sparkles")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.catGold)
                .offset(x: 80, y: 60)
                .opacity(isBreathing ? 0.85 : 0.35)
            
            Image(systemName: "heart.fill")
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "E68875"))
                .offset(x: -70, y: 65)
                .opacity(isBreathing ? 0.5 : 0.9)
        }
    }
    
    // MARK: - 底部主要抽籤操作按鈕
    private var bottomActionBar: some View {
        Button {
            triggerFortuneDraw()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.system(size: 16, weight: .bold))
                Text("虔心祈籤 · 揭曉今日喵運")
                    .font(.huninn(size: 16))
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 14))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                LinearGradient(
                    colors: [Color.catCaramel, Color(hex: "BD5F3C")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: Color.catCaramel.opacity(0.35), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 呼嚕嚕彩蛋橫幅
    private var easterEggBannerView: some View {
        HStack(spacing: 10) {
            Text("💖")
                .font(.huninn(size: 20))
            VStack(alignment: .leading, spacing: 2) {
                Text("貓咪發出呼嚕嚕聲音～ (幸運加倍！)")
                    .font(.huninn(size: 13))
                    .foregroundColor(.catDarkBrown)
                Text("喵神的祝福圍繞著你，今日大吉利 🐾")
                    .font(.huninn(size: 11))
                    .foregroundColor(.catSecondaryBrown)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(hex: "FFF7EC"))
                .shadow(color: Color.catCaramel.opacity(0.18), radius: 10, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.catGold.opacity(0.5), lineWidth: 1.5)
                )
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - 點擊貓爪互動邏輯
    private func handlePawTap() {
        HapticManager.medium()
        tapCount += 1
        
        // 1. 貓爪按壓縮放彈跳動畫
        withAnimation(.spring(response: 0.22, dampingFraction: 0.45)) {
            pawScale = 0.86
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                pawScale = 1.14
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                    pawScale = 1.0
                }
            }
        }
        
        // 2. 觸發蓋章衝擊波
        shockwaveScale = 0.8
        shockwaveOpacity = 0.8
        withAnimation(.easeOut(duration: 0.45)) {
            shockwaveScale = 1.45
            shockwaveOpacity = 0.0
        }
        
        // 3. 噴發可愛粒子特效
        spawnParticles()
        
        // 4. 彩蛋檢查：每滿 5 次觸發
        if tapCount % 5 == 0 {
            triggerEasterEgg()
        }
        
        // 5. 動畫完成後自動導航至 ResultView
        // 取消先前累積的自動跳轉任務，若使用者連續快速敲擊可持續累積彩蛋，停止後0.6秒自動進入結果頁
        navigationTask?.cancel()
        navigationTask = Task {
            try? await Task.sleep(nanoseconds: 600_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                navigateToResult = true
            }
        }
    }
    
    // MARK: - 呼嚕嚕彩蛋觸發
    private func triggerEasterEgg() {
        HapticManager.success()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showEasterEggBanner = true
        }
        
        // 額外噴發金色星星雨粒子
        for _ in 0..<8 {
            let p = TapParticle(
                symbol: "⭐",
                offset: CGSize(width: CGFloat.random(in: -100...100), height: CGFloat.random(in: -120...0)),
                opacity: 1.0,
                scale: CGFloat.random(in: 1.0...1.5),
                rotation: Double.random(in: 0...360)
            )
            particles.append(p)
        }
        
        // 定時自動收回彩蛋提示
        easterEggTimer?.cancel()
        easterEggTimer = Task {
            try? await Task.sleep(nanoseconds: 3_500_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                withAnimation(.easeOut(duration: 0.35)) {
                    showEasterEggBanner = false
                }
            }
        }
    }
    
    // MARK: - 噴發粒子
    private func spawnParticles() {
        let count = 10
        var newParticles: [TapParticle] = []
        for _ in 0..<count {
            let symbol = availableParticleSymbols.randomElement() ?? "🐾"
            let p = TapParticle(
                symbol: symbol,
                offset: .zero,
                opacity: 1.0,
                scale: CGFloat.random(in: 0.8...1.3),
                rotation: Double.random(in: -30...30)
            )
            newParticles.append(p)
        }
        
        particles.append(contentsOf: newParticles)
        
        // 粒子爆炸散開動畫
        for item in newParticles {
            let angle = Double.random(in: 0...(2 * .pi))
            let radius = CGFloat.random(in: 80...150)
            let targetOffset = CGSize(
                width: cos(angle) * radius,
                height: sin(angle) * radius - CGFloat.random(in: 20...50) // 向上微飄
            )
            
            withAnimation(.easeOut(duration: 0.75)) {
                if let idx = particles.firstIndex(where: { $0.id == item.id }) {
                    particles[idx].offset = targetOffset
                    particles[idx].opacity = 0.0
                    particles[idx].scale *= 0.6
                    particles[idx].rotation += Double.random(in: 90...270)
                }
            }
        }
        
        // 定時清理粒子
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            particles.removeAll { $0.opacity == 0 }
        }
    }
    
    // MARK: - 直接手動觸發抽籤
    private func triggerFortuneDraw() {
        navigationTask?.cancel()
        HapticManager.medium()
        
        withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
            pawScale = 0.85
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                pawScale = 1.0
            }
            navigateToResult = true
        }
    }
}
