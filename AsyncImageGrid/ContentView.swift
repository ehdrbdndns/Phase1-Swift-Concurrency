
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ImageViewModel(
        imageCacheService: ImageCacheService.shared
    )
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.imageItems) { item in
                        ImageCell(
                            viewModel: viewModel,
                            item: item
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Lazy Image Grid")
        }
    }
}

#Preview {
    ContentView()
}
