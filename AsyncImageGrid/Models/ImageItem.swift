//
//  ImageItem.swift
//  AsyncImageGrid
//
//  Created by Donggyun Yang on 7/26/25.
//
import Foundation
import UIKit

struct ImageItem: Identifiable {
    let id: UUID = UUID()
    let imageUrl: URL
    var image: UIImage?
}

extension ImageItem {
    static let TEST_IMAGES_1000 = (1...1000).map { id in "https://picsum.photos/id/\(id)/200/200" }
}
