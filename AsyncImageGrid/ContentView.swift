import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ImageViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.imageItems.indices, id: \.self) { index in
                        ImageCell(
                            viewModel: viewModel,
                            item: viewModel.imageItems[index],
                            index: index
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
