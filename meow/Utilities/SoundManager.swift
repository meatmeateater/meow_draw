import Foundation
import AVFoundation

// MARK: - 音效播放管理器（全音訊操作移至專用背景佇列，徹底消除主執行緒 Hang Risk）
final class SoundManager: @unchecked Sendable {
    static let shared = SoundManager()
    
    private let audioQueue = DispatchQueue(label: "com.meow.soundmanager.audioQueue", qos: .userInitiated)
    private var audioPlayer: AVAudioPlayer?
    private var isSessionConfigured = false
    
    private init() {
        audioQueue.async { [weak self] in
            self?.setupAudioSessionAndPreload()
        }
    }
    
    /// 在背景佇列設定 AVAudioSession 並預先載入貓叫聲檔案
    private func setupAudioSessionAndPreload() {
        configureAudioSessionOnQueue()
        
        let soundURL = Bundle.main.url(forResource: "cat_meow", withExtension: "wav")
            ?? Bundle.main.url(forResource: "cat_meow", withExtension: "mp3")
            
        guard let validURL = soundURL else {
            print("Sound file 'cat_meow' not found in Bundle")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: validURL)
            player.volume = 1.0
            player.prepareToPlay()
            self.audioPlayer = player
        } catch {
            print("Failed to preload cat meow sound: \(error)")
        }
    }
    
    /// 在背景佇列配置音訊工作階段（非主執行緒，避免 AVAudioSession_iOS.mm / SessionCore 阻塞）
    private func configureAudioSessionOnQueue() {
        #if os(iOS)
        guard !isSessionConfigured else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
            isSessionConfigured = true
        } catch {
            print("Failed to configure AVAudioSession: \(error)")
        }
        #endif
    }
    
    /// 播放貓咪叫聲音效（外部呼叫即刻返回，所有 AVAudioPlayer 與 Session 操作均派發至背景佇列）
    func playMeow() {
        audioQueue.async { [weak self] in
            guard let self = self else { return }
            self.configureAudioSessionOnQueue()
            
            if let player = self.audioPlayer {
                player.currentTime = 0
                player.play()
            } else {
                let soundURL = Bundle.main.url(forResource: "cat_meow", withExtension: "wav")
                    ?? Bundle.main.url(forResource: "cat_meow", withExtension: "mp3")
                guard let validURL = soundURL else {
                    print("Sound file 'cat_meow' not found in Bundle")
                    return
                }
                do {
                    let player = try AVAudioPlayer(contentsOf: validURL)
                    player.volume = 1.0
                    player.prepareToPlay()
                    self.audioPlayer = player
                    player.play()
                } catch {
                    print("Failed to play cat meow sound: \(error)")
                }
            }
        }
    }
    
    /// 停止音效播放
    func stopMeow() {
        audioQueue.async { [weak self] in
            self?.audioPlayer?.stop()
        }
    }
    
    // MARK: - 相容別名
    func playPurr() {
        playMeow()
    }
    
    func stopPurr() {
        stopMeow()
    }
}
