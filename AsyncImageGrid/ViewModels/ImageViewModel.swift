//
//  ImageViewModel.swift
//  AsyncImageGrid
//
//  Created by Donggyun Yang on 7/26/25.
//
import Foundation 
import UIKit

enum ImageError: Error {
    case cannotLoadImage
}

class ImageViewModel: ObservableObject {
    @Published var imageItems: [ImageItem] = []
    
    init() {
        self.imageItems = ImageItem.TEST_IMAGES_1000
            .compactMap { URL(string: $0) }
            .map { ImageItem(imageUrl: $0, image: nil) }
    }
    
    func loadImage(at index: Int) async -> Void {
        do {
            let image = try await downloadImage(from: self.imageItems[index].imageUrl)
            
            await MainActor.run {
                self.imageItems[index].image = image
            }
        } catch {
            print("이미지 로딩에 실패했습니다. \(error)")
        }
    }
    
    func fetchAllImages() async throws -> Void {
        try await withThrowingTaskGroup(of: Result<(Int, UIImage), Error>.self) { group in
            for (index, item) in self.imageItems.enumerated() {
                group.addTask {
                    do {
                        let image = try await self.downloadImage(from: item.imageUrl)
                        return .success((index, image))
                    } catch {
                        return .failure(error)
                    }
                }
            }
            
            for try await result in group {
                switch result {
                case .success(let (index, image)):
                    await MainActor.run {
                        self.imageItems[index].image = image
                    }
                    break
                case .failure(let error):
                    print("이미지 다운로드 에러 \(error)")
                }
            }
        }
    }
    
    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw ImageError.cannotLoadImage
        }
        
        return image
    }
}
