//
//  Feed.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-09.
//

import SwiftUI

struct Feed: View {
	
	var challenge: String? = nil
	
	var screenTitle: [Sorting : String] = [.top: "Top", .new: "New"]
	
	@State private var searchText = ""
	@State var sortMethod = SORTING.NEW
	
	@ObservedObject private var viewModel = FeedViewModel()
	
	@EnvironmentObject var app: AppStore
	
	func refresh (nextPage: Bool = false) {
		switch(self.sortMethod) {
		case SORTING.NEW :
			viewModel.fetchData(byNew: true, nextPage: nextPage, challenge: challenge ?? nil)
			break;
		case SORTING.ALL:
			viewModel.fetchData(maxTimestamp: 0, nextPage: nextPage, challenge: challenge ?? nil)
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
			List {
				if ((challenge) != nil) {
					Section {
						CurrentChallengeCard()
							.listRowInsets(EdgeInsets())
					}
				}
				if (viewModel.state == States.LOADING && viewModel.posts.count == 0) {
					ProgressView()
				} else if (viewModel.posts.count == 0) {
					Empty()
				} else {
					ForEach(viewModel.posts.indices, id: \.self) { index in
						Section {
							ZStack {
								// "fake" button to disable onTap on items of the list.
								Button(action: {}){}.buttonStyle(PlainButtonStyle())
								HStack {
									Spacer()
									PostCard(
										desc: viewModel.posts[index].desc,
										username: viewModel.posts[index].user.displayName,
										userId: viewModel.posts[index].user.id,
										likesCount: viewModel.posts[index].likes.count,
										comments: viewModel.posts[index].comments ?? [],
										id: viewModel.posts[index].id ?? "",
										data: viewModel.posts[index].data,
										likes: viewModel.posts[index].likes,
										timestamp: viewModel.posts[index].timestamp
									)
									.contextMenu {
										Button(action: { }) { HStack {Text("See in fullscreen"); Spacer(); Image(systemName: "arrow.up.left.and.arrow.down.right") }}
										Button(action: {UIPasteboard.general.string = viewModel.posts[index].id ?? ""}) { HStack {Text("Copy post ID"); Spacer(); Image(systemName: "doc.on.doc")}}
									}
									.frame(maxWidth: 350)
									Spacer()
								}
							}
							.listRowInsets(EdgeInsets())
							.onAppear { onPostAppear(index) }
						}.listSectionSeparator(.hidden) // TODO: this doesn't seem to work, try something else to reduce space between posts
					}
				}
			}
			.refreshable(action: {refresh()})
//			.listStyle(PlainListStyle()) Which one looks better ? 🤔
			.listStyle(InsetGroupedListStyle())
		}
		.navigationTitle(self.sortMethod == SORTING.NEW ? "Latest" : "Top Posts")
		.toolbar {
			HStack {
				Menu {
					Text("Sort by")
					Button(action: {setNewSorting(SORTING.NEW)}) { HStack {Text("New posts"); Spacer(); if sortMethod == SORTING.NEW { Image(systemName: "checkmark") } }}
					Button(action: {setNewSorting(SORTING.ALL)}) { HStack {Text("Top of all time"); Spacer(); if sortMethod == SORTING.ALL { Image(systemName: "checkmark") } }}
				} label: {
					Image(systemName: "arrow.up.arrow.down")
				}
				NavigationLink(destination: NewsScreen()) {
					Image(systemName: "bell.badge")
				}
			}
		}
		//        .searchable(text: $searchText, prompt: "Search for anything")
		.onAppear {
			if (viewModel.posts.isEmpty && viewModel.state == States.IDLE) {
				self.setNewSorting(SORTING.NEW)
			}
		}
	}
}

//struct Feed_Previews: PreviewProvider {
//    static var previews: some View {
//        Feed()
//    }
//}
