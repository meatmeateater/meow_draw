import SwiftUI
import CoreText

@main struct MyApp: App {
    init() {
        registerCustomFont()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func registerCustomFont() {
        guard let fontURL = Bundle.main.url(forResource: "jf-openhuninn-2.1", withExtension: "ttf") else {
            print("⚠️ [Font] Cannot find jf-openhuninn-2.1.ttf in Bundle.main")
            return
        }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
        if success {
            print("✅ [Font] Successfully registered jf-openhuninn-2.1")
        } else {
            print("⚠️ [Font] Registration failed or already registered: \(String(describing: error?.takeRetainedValue()))")
        }
    }
}
