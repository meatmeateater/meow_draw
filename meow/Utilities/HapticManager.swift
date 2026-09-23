import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Haptic Feedback Manager
enum HapticManager {
    static func light() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        #elseif canImport(AppKit)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        #endif
    }
    
    static func medium() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        #elseif canImport(AppKit)
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
        #endif
    }
    
    static func heavy() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        #elseif canImport(AppKit)
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
        #endif
    }
    
    static func success() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        #elseif canImport(AppKit)
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
        #endif
    }
    
    static func selection() {
        #if canImport(UIKit)
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        #elseif canImport(AppKit)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        #endif
    }
}
