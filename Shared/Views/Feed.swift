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
	@State var screenWidth = 0.0

	@ObservedObject private var viewModel = FeedViewModel()
	
	@EnvironmentObject var session: SessionStore
	@EnvironmentObject var app: AppStore
	
	func refresh (nextPage: Bool = false) {
		switch(self.sortMethod) {
		case SORTING.NEW:
			viewModel.fetchData(byNew: true, nextPage: nextPage, challenge: challenge ?? nil)
			break;
		case SORTING.ALL:
			viewModel.fetchData(maxTimestamp: 0, nextPage: nextPage, challenge: challenge ?? nil)
			break;
		}
		if (nextPage == false) {
			session.loadNotifications()
		}
	}
	
	func setNewSorting (_ newSort: SORTING) {
		self.sortMethod = newSort
		viewModel.emptyList()
		self.refresh()
	}
	
	func onPostAppear (_ index: Int) {
		if (index == viewModel.posts.count - 1 && viewModel.state != States.LOADING) {
			self.refresh(nextPage: true)
		}
	}
	
	func getColumns () -> [GridItem] {
		let postWidth = 350.0
		let numberOfColumns = screenWidth / (postWidth + 8)
		return [GridItem](repeating: GridItem(.flexible()), count: Int(numberOfColumns))
	}
	
	var body: some View {
		ZStack {
			GeometryReader { geometry in
				HStack{}.onAppear{ self.screenWidth = geometry.size.width }
			}
			ColorManager.screenBackground.ignoresSafeArea()
			VStack {
				
				ScrollView {
					if ((challenge) != nil) {
						Section {
							CurrentChallengeCard()
								.listRowInsets(EdgeInsets())
						}
					}
					if (viewModel.state == States.LOADING && viewModel.posts.count == 0) {
						HStack {
							Spacer()
							ProgressView()
							Spacer()
						}
					} else if (viewModel.posts.count == 0) {
						Empty()
					} else {
						LazyVGrid(columns: getColumns(), spacing: 20) {
							ForEach(viewModel.posts.indices, id: \.self) { index in
								ZStack {
									// "fake" button to disable onTap on items of the list.
									Button(action: {}){}.buttonStyle(PlainButtonStyle())
									HStack {
										PostCard(
											desc: viewModel.posts[index].desc,
											userRef: viewModel.posts[index].userRef,
											likesCount: viewModel.posts[index].likes.count,
											comments: viewModel.posts[index].comments ?? [],
											id: viewModel.posts[index].id ?? "",
											data: viewModel.posts[index].data,
											likes: viewModel.posts[index].likes,
											timestamp: viewModel.posts[index].timestamp
										)
										.contextMenu {
											Button(action: {UIPasteboard.general.string = viewModel.posts[index].id ?? ""}) { HStack {Text("Copy post ID"); Spacer(); Image(systemName: "doc.on.doc")}}
										}
										.frame(maxWidth: screenWidth < 350 ? screenWidth : 350)
										.frame(height: 500)
									}
								}
								.listRowInsets(EdgeInsets())
								.onAppear { onPostAppear(index) }
							}
						}
					}
				}
				.refreshable(action: {refresh()})
			}
			.navigationTitle(self.sortMethod == SORTING.NEW ? "Latest" : "Top Posts")
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					NavigationLink(destination: NewsScreen()) {
						Image(systemName: "sparkles")
					}
				}
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					Menu {
						Text("Sort by")
						Button(action: {setNewSorting(SORTING.NEW)}) { HStack {Text("New posts"); Spacer(); if sortMethod == SORTING.NEW { Image(systemName: "checkmark") } }}
						Button(action: {setNewSorting(SORTING.ALL)}) { HStack {Text("Top of all time"); Spacer(); if sortMethod == SORTING.ALL { Image(systemName: "checkmark") } }}
					} label: {
						Image(systemName: "arrow.up.arrow.down")
					}
					NavigationLink(destination: NotificationsScreen()) {
						Image(systemName: session.notifications.count > 0 ? "bell.badge" : "bell")
					}
				}
			}
			//.searchable(text: $searchText, prompt: "Search for anything")
			.onAppear {
				if (viewModel.posts.isEmpty && viewModel.state == States.IDLE) {
					self.setNewSorting(SORTING.NEW)
				}
			}
		}
	}
}

//struct Feed_Previews: PreviewProvider {
//    static var previews: some View {
//        Feed()
//    }
//}
