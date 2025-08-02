
import Foundation 
import UIKit

enum ImageError: Error {
    case cannotLoadImage
    case outOfRange
}

class ImageViewModel: ObservableObject {
    @Published var imageItems: [ImageItem]
    private let imageCacheService: ImageCacheService
    
    init(imageCacheService: ImageCacheService) {
        self.imageCacheService = imageCacheService
        
        self.imageItems = ImageItem.TEST_IMAGES_1000
            .compactMap { URL(string: $0) }
            .map { ImageItem(imageUrl: $0) }
    }
    
    @MainActor
    func loadImage(for item: ImageItem) async -> UIImage? {
        let url = NSString(string: item.imageUrl.absoluteString)
        if let image = imageCacheService.getImage(URL: url) {
            return image
        }
        
        do {
            let image = try await downloadImage(from: item.imageUrl)
            imageCacheService.setImage(URL: url, image: image)
            return image
        } catch {
            print("이미지 로딩에 실패했습니다. \(error)")
            return nil
        }
    }
    
    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw ImageError.cannotLoadImage
        }
        
        return image
    }
    
    // Note: fetchAllImages is kept for future reference but is not used in the Lazy Loading architecture.
    func fetchAllImages() async throws {
        // ... (implementation from previous steps)
    }
}
