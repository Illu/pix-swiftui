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
    @State private var sortMethod = SORTING.ALL
    
    @ObservedObject private var viewModel = FeedViewModel()
    
    @EnvironmentObject var app: AppStore
    
    func refresh (nextPage: Bool = false) {
        switch(self.sortMethod) {
        case SORTING.NEW :
            viewModel.fetchData(byNew: true, nextPage: nextPage)
            break;
        case SORTING.ALL:
            viewModel.fetchData(maxTimestamp: 0, nextPage: nextPage)
            break;
        }
    }
    
    func setNewSorting (_ newSort: SORTING) {
        self.sortMethod = newSort
        viewModel.emptyList()
        self.refresh()
    }
    
    func onPostAppear (_ index: Int) {
        if (index == viewModel.posts.count - 1) {
            self.refresh(nextPage: true)
        }
    }
    
    var body: some View {
        VStack {
            if (viewModel.state == States.LOADING && viewModel.posts.count == 0) {
                ProgressView()
            } else if (viewModel.posts.count == 0) {
                Empty()
            } else {
                List(viewModel.posts.indices, id: \.self) { index in
                    Section {
                        ZStack {
                            // "fake" button to disable onTap on items of the list.
                            Button(action: {}){}.buttonStyle(PlainButtonStyle())
                            PostCard(
                                desc: viewModel.posts[index].desc,
                                username: viewModel.posts[index].user.displayName,
                                userId: viewModel.posts[index].user.id,
                                likesCount: viewModel.posts[index].likes.count,
                                comments: viewModel.posts[index].comments ?? [],
                                id: viewModel.posts[index].id ?? "",
                                data: viewModel.posts[index].data,
                                likes: viewModel.posts[index].likes
                            )
                        }
                        .onAppear { onPostAppear(index) }
                        .contextMenu {
                            Text("ID - " + (viewModel.posts[index].id ?? ""))
                        }
                    }
                }
                .refreshable(action: {refresh()})
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle(self.sortMethod == SORTING.NEW ? "Latest" : "Trending")
        .toolbar {
            HStack {
                Menu {
                    Text("Sort by")
                    Button(action: {setNewSorting(SORTING.NEW)}) { HStack {Text("New posts"); Spacer(); if sortMethod == SORTING.NEW { Image(systemName: "checkmark") } }}
                    Button(action: {setNewSorting(SORTING.ALL)}) { HStack {Text("Top of all time"); Spacer(); if sortMethod == SORTING.ALL { Image(systemName: "checkmark") } }}
                } label: {
                    Image(systemName: "clock")
                }
                Button(action: {app.showLoginSheet()}) { Image(systemName: "bell.badge") }
            }
        }
        .searchable(text: $searchText, prompt: "Search for anything")
        .onAppear {
            if (viewModel.posts.isEmpty && viewModel.state == States.IDLE) {
                self.setNewSorting(SORTING.ALL)
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
