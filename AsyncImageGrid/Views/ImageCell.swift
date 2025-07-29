
import SwiftUI

struct ImageCell: View {
    @ObservedObject var viewModel: ImageViewModel
    
    // 1. 셀이 보여줘야 할 데이터와, 로딩을 요청할 ViewModel을 받습니다.
    let item: ImageItem
    let index: Int

    var body: some View {
        ZStack {
            // 2. if-let을 사용하여 안전하게 이미지를 표시합니다.
            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                // 3. 플레이스홀더
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(8)
        .clipped()
        .onAppear { // 4. 이 셀이 화면에 나타날 때...
            Task {
                // ...ViewModel에게 이 셀에 해당하는 이미지를 로드해달라고 요청합니다.
                await viewModel.loadImage(at: index)
                print("\(index)번째 이미지 로드 완료")
            }
        }
    }
}
