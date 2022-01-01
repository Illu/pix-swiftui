//
//  HomeScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI

struct HomeScreen: View {
    
    private var screenTitle: [Sorting : String] = [.top: "Top", .new: "New"]
    
    @State private var searchText = ""
    @State private var showLoginSheet = false
    
    @ObservedObject private var viewModel = FeedViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    ForEach(viewModel.posts, id: \.self.id) { post in
                        HStack {
                            Spacer()
                            PostCard(
                                desc: post.desc,
                                username: post.user.displayName,
                                likesCount: post.likes.count,
                                comments: post.comments ?? [],
                                data: post.data
                            )
                            Spacer()
                        }
                        .padding([.leading, .bottom, .trailing], 10.0)
                    }
                } // TODO: make this scroll view refreshable
            }
            .navigationTitle("Trending")
            .toolbar {
                HStack {
                    Button(action: {showLoginSheet.toggle()}) { Image(systemName: "magnifyingglass") }
                    Button(action: {print("tap bell")}) { Image(systemName: "bell.badge") }
                }
            }
            .searchable(text: $searchText, prompt: "Search for anything")
            .onAppear {
                if viewModel.posts.isEmpty {
                    self.viewModel.fetchData()
                }
            }
        }
        .background(ColorManager.screenBackground)
        .fullScreenCover(
            isPresented: $showLoginSheet,
            onDismiss: { self.showLoginSheet = false }
        ) {
            NavigationView {
                LoginMenuScreen()
                    .toolbar {
                        HStack {
                            Button(action: {showLoginSheet = false}) { Text("Cancel") }
                        }
                    }
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeScreen()
        }
    }
}
