import Foundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - 貓咪圖片本機快取與儲存管理器
final class FortuneImageManager {
    static let shared = FortuneImageManager()
    
    #if canImport(UIKit)
    private let memoryCache = NSCache<NSString, UIImage>()
    #endif
    private let fileManager = FileManager.default
    
    private var imagesDirectoryURL: URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let dir = paths[0].appendingPathComponent("FortuneImages", isDirectory: true)
        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }
    
    private init() {
        #if canImport(UIKit)
        memoryCache.countLimit = 120
        #endif
    }
    
    #if canImport(UIKit)
    /// 取得或載入本機圖片
    func loadImage(fileName: String?) -> UIImage? {
        guard let fileName = fileName, !fileName.isEmpty else { return nil }
        let key = fileName as NSString
        if let cached = memoryCache.object(forKey: key) {
            return cached
        }
        let fileURL = imagesDirectoryURL.appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        memoryCache.setObject(image, forKey: key)
        return image
    }
    
    /// 儲存圖片資料至本機沙盒
    @discardableResult
    func saveImage(data: Data, for cardId: UUID) -> String? {
        let fileName = "\(cardId.uuidString).jpg"
        let fileURL = imagesDirectoryURL.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            if let image = UIImage(data: data) {
                memoryCache.setObject(image, forKey: fileName as NSString)
            }
            return fileName
        } catch {
            print("Failed to save image locally: \(error)")
            return nil
        }
    }
    
    /// 取得現有本機快取圖片，若無則自網路下載並儲存至本機
    func getOrDownloadImage(for card: FortuneCard) async -> (image: UIImage, fileName: String)? {
        // 1. 若已經有記錄檔名且檔案存在，直接使用本機圖片
        if let localName = card.localImageFileName, let existingImage = loadImage(fileName: localName) {
            return (existingImage, localName)
        }
        
        // 2. 若無本機快取，透過 URL 下載
        guard let url = URL(string: card.imageURLString) else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let image = UIImage(data: data) else {
                return nil
            }
            
            // 3. 下載完成後寫入本機硬碟持久化保存
            if let fileName = saveImage(data: data, for: card.id) {
                return (image, fileName)
            }
            return (image, "\(card.id.uuidString).jpg")
        } catch {
            print("Failed to download image from \(card.imageURLString): \(error)")
            return nil
        }
    }
    #endif
    
    /// 刪除指定本機圖片
    func deleteImage(fileName: String?) {
        guard let fileName = fileName, !fileName.isEmpty else { return }
        #if canImport(UIKit)
        memoryCache.removeObject(forKey: fileName as NSString)
        #endif
        let fileURL = imagesDirectoryURL.appendingPathComponent(fileName)
        try? fileManager.removeItem(at: fileURL)
    }
    
    /// 清空所有已儲存的卡片照片
    func clearAllImages() {
        #if canImport(UIKit)
        memoryCache.removeAllObjects()
        #endif
        try? fileManager.removeItem(at: imagesDirectoryURL)
    }
}
