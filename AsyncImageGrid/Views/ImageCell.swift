import SwiftUI

struct ImageCell: View {
    @ObservedObject var viewModel: ImageViewModel
    let item: ImageItem

    @State private var image: UIImage? = nil
    
    var body: some View {
        ZStack {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(8)
        .clipped()
        .onAppear {
            // 이미지가 로드된 상태가 아니라면 로드를 시도합니다.
            if image == nil {
                Task {
                    self.image = await viewModel.loadImage(for: item)
                }
            }
        }
    }
}