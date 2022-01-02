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
    @State private var sortMethod = SORTING.MONTH
    
    @ObservedObject private var viewModel = FeedViewModel()
    
    func setNewSorting (_ newSort: SORTING) {
        self.sortMethod = newSort
        
        switch(newSort) {
        case SORTING.NEW :
            viewModel.fetchData(byNew: true)
            break;
        case SORTING.MONTH :
            viewModel.fetchData(maxTimestamp: convertDateToTimestamp(date: Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!))
            break;
        case SORTING.YEAR:
            viewModel.fetchData(maxTimestamp: convertDateToTimestamp(date: Calendar.current.date(byAdding: .year, value: -1, to: Date.now)!))
            break;
        case SORTING.ALL:
            viewModel.fetchData(maxTimestamp: 0)
            break;
        }
    }
    
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
                                userId: post.user.id,
                                likesCount: post.likes.count,
                                comments: post.comments ?? [],
                                id: post.id ?? "",
                                data: post.data,
                                likes: post.likes
                            ).contextMenu {
                                Text(post.id ?? "")
                            }
                            Spacer()
                        }
                        .padding([.leading, .bottom, .trailing], 10.0)
                    }
                } // TODO: make this scroll view refreshable
            }
            .navigationTitle(self.sortMethod == SORTING.NEW ? "Latest" : "Trending")
            .toolbar {
                HStack {
                    Menu {
                        Text("Sort by...")
                        Button(action: {setNewSorting(SORTING.NEW)}) { HStack {Text("New posts"); Spacer(); if sortMethod == SORTING.NEW { Image(systemName: "checkmark") } }}
//                        Button(action: {setNewSorting(SORTING.MONTH)}) { HStack {Text("Top of the month"); Spacer(); if sortMethod == SORTING.MONTH { Image(systemName: "checkmark") } }}
//                        Button(action: {setNewSorting(SORTING.YEAR)}) { HStack {Text("Top of the year"); Spacer(); if sortMethod == SORTING.YEAR { Image(systemName: "checkmark") } }}
                        Button(action: {setNewSorting(SORTING.ALL)}) { HStack {Text("Top of all time"); Spacer(); if sortMethod == SORTING.ALL { Image(systemName: "checkmark") } }}
                    } label: {
                        Image(systemName: "clock")
                    }
                    Button(action: {showLoginSheet.toggle()}) { Image(systemName: "bell.badge") }
                }
            }
            .searchable(text: $searchText, prompt: "Search for anything")
            .onAppear {
                if (viewModel.posts.isEmpty && viewModel.state == States.IDLE) {
                    self.setNewSorting(SORTING.ALL)
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
