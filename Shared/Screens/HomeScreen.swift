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
            VStack {
                ScrollView {
                    ForEach(viewModel.posts) { post in
                        PostCard(
                            desc: post.desc,
                            username: post.user.displayName,
                            likesCount: post.likes.count,
                            comments: post.comments ?? [],
                            data: post.data
                        )
                    }
                }
            }
            .onAppear() {
                self.viewModel.fetchData()
            }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
        HomeScreen().preferredColorScheme(.dark)
    }
}
