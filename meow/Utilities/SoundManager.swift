import Foundation
import AVFoundation

// MARK: - 音效播放管理器
final class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        configureAudioSession()
    }
    
    /// 設定音訊工作階段（僅限 iOS，支援與背景音樂混合並遵循靜音開關）
    private func configureAudioSession() {
        #if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error)")
        }
        #endif
    }
    
    /// 播放貓咪呼嚕嚕音效
    func playPurr() {
        #if os(iOS)
        configureAudioSession()
        #endif
        
        guard let soundURL = Bundle.main.url(forResource: "cat_purr", withExtension: "wav") else {
            print("Sound file 'cat_purr.wav' not found in Bundle")
            return
        }
        
        do {
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play cat purr sound: \(error)")
        }
    }
    
    /// 停止音效播放
    func stopPurr() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
