//
//  HomeScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI

struct HomeScreen: View {
    
    private var screenTitle: [Sorting : String] = [.top: "Top", .new: "New"]
    
    @ObservedObject private var viewModel = FeedViewModel()
    
    var body: some View {
        ZStack {
            ColorManager.screenBackground
            VStack {
                List(viewModel.posts) { post in
                    PostCard(
                        desc: post.desc,
                        username: post.user.displayName,
                        likesCount: post.likes.count,
                        comments: post.comments ?? [],
                        data: post.data
                    )
                }
                .listStyle(.sidebar)
                .refreshable {
                    self.viewModel.fetchData()
                }
            }
            .background(ColorManager.screenBackground)
            .navigationTitle("Trending")
            .toolbar {
                HStack {
                    Button(action: {print("tap search")}) { Image(systemName: "magnifyingglass") }
                    Button(action: {print("tap bell")}) { Image(systemName: "bell.badge") }
                }
            }
            .onAppear {
                if viewModel.posts.isEmpty {
                    self.viewModel.fetchData()
                }
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
        HomeScreen()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            .previewDisplayName("iPad Pro")
    }
}
