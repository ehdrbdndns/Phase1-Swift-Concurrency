//
//  ImageCacheService.swift
//  AsyncImageGrid
//
//  Created by Donggyun Yang on 8/2/25.
//

import Foundation
import UIKit

final class ImageCacheService {
    private let TOTAL_COST_LIMIT = 1 * 1024 * 1024
    
    private var cache: NSCache<NSString, UIImage>
    
    static let shared = ImageCacheService()
    
    init() {
        cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = TOTAL_COST_LIMIT
    }
    
    func getImage(URL: NSString) -> UIImage? {
        return cache.object(forKey: URL)
    }
    
    func setImage(URL: NSString, image: UIImage) -> Void {
        let cost: Int = Int(image.size.width * image.size.height * image.scale * image.scale)
        cache.setObject(image, forKey: URL, cost: cost)
    }
}
