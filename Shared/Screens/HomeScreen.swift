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
    
    func setNewSorting (_ newSort: SORTING) {
        self.sortMethod = newSort
        
        switch(newSort) {
        case SORTING.NEW :
            viewModel.fetchData(byNew: true)
            break;
//        case SORTING.MONTH :
//            viewModel.fetchData(maxTimestamp: convertDateToTimestamp(date: Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!))
//            break;
//        case SORTING.YEAR:
//            viewModel.fetchData(maxTimestamp: convertDateToTimestamp(date: Calendar.current.date(byAdding: .year, value: -1, to: Date.now)!))
//            break;
        case SORTING.ALL:
            viewModel.fetchData(maxTimestamp: 0)
            break;
        }
    }
    
    func onPostAppear (_ index: Int) {
        if (index == viewModel.posts.count - 1) {
            print("Loading more!")
            switch(self.sortMethod) {
            case SORTING.NEW :
                viewModel.fetchData(byNew: true, nextPage: true)
                break;
            case SORTING.ALL:
                viewModel.fetchData(maxTimestamp: 0, nextPage: true)
                break;
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
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
                .refreshable(action: {setNewSorting(sortMethod)})
                .listStyle(InsetGroupedListStyle())
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
        .background(ColorManager.screenBackground)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeScreen()
        }
    }
}
