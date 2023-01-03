//
//  NewsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-07.
//

import SwiftUI
import FirebaseFirestore

struct NewsScreen: View {
	
	@State var newsData: News? = nil
	@State var state: States = States.IDLE
	@State var comments: [Comment] = []

	@EnvironmentObject var session: SessionStore

	var db = Firestore.firestore()
	
	func loadData () {
		self.state = States.LOADING
		let docRef = self.db.collection("News").document("current")
		docRef.getDocument { document, error in
			if let error = error as NSError? {
				print ("error: \(error.localizedDescription)")
				self.state = States.ERROR
			}
			else {
				if let document = document {
					do {
						let newsData = try document.data(as: News.self)
						self.newsData = newsData ?? nil
						self.state = States.SUCCESS
					}
					catch {
						print(error)
						self.state = States.ERROR
					}
				}
			}
			self.loadComments()
		}
	}
	
	func loadComments () {
		self.state = States.LOADING
		let docRef = self.db.collection("News").document("current")
		docRef.getDocument { document, error in
			if let error = error as NSError? {
				print ("error: \(error.localizedDescription)")
				self.state = States.SUCCESS
			}
			else {
				if let document = document {
					do {
						let post = try document.data(as: News.self)
						self.comments = post?.comments ?? []
						self.state = States.SUCCESS
					}
					catch {
						print(error)
						self.state = States.ERROR
					}
				}
			}
		}
	}
	
	func deleteComment (comment: Comment) {
		let updateReference = self.db.collection("News").document("current")
		updateReference.updateData([
			"comments": FieldValue.arrayRemove(
				[
					["text": comment.text,
					 "timestamp": comment.timestamp,
					 "userRef": comment.userRef
					]
				]
			)
		])
		self.loadComments()
	}
	
	func isCommentFromCurrentUser (comment: Comment) -> Bool {
		if (session.session != nil) {
			return db.document("Users/\(self.session.session?.uid ?? "")") == comment.userRef
		}
		return false
	}
	
    var body: some View {
		ZStack {
			ColorManager.screenBackground.ignoresSafeArea()
			ScrollView {
				VStack {
					if (state == States.LOADING) {
						ProgressView()
					} else if (newsData == nil) {
						Text("Something went wrong while retrieving the latest news 😥").padding(.bottom, 30)
						Button(action: {self.loadData()}) {
							LargeButton(title: "Try again", withBackground: true)
						}
					}
					if (newsData != nil) {
						VStack {
							Image("koala").padding(.vertical, 30)
							Text("\(newsData!.title)").fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).padding(16).font(.title)
							ForEach(newsData!.desc, id: \.self) { paragraph in
								Text("\(paragraph)").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding(16).fixedSize(horizontal: false, vertical: true)
							}
							Spacer()
	//						NavigationLink(destination: RequestNewFeatureScreen()) {
	//							Text("Help improve the App")
	//						}
							Spacer()
						}
					}
					Text("Comments").fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top], 16).font(.title)
					
					VStack {
						if (state == States.LOADING) {
							ProgressView()
						} else {
							ForEach(comments, id: \.self) { comment in
								CommentView(comment: comment, userRef: comment.userRef)
									.padding(.horizontal)
									.contextMenu {
										Button(action: { UIPasteboard.general.string = comment.text }) { HStack {Text("Copy comment"); Spacer(); Image(systemName: "doc.on.doc")}}
										if (session.isAdmin || isCommentFromCurrentUser(comment: comment) ) {
											Button(action: { deleteComment(comment: comment) }) { HStack {Text("Delete comment"); Spacer(); Image(systemName: "trash")}}
										}
									}
							}
						}
						CommentTextInput(postId: "current", news: true, authorId: nil, commentsCount: comments.count, loadData: self.loadComments)
							.padding(.top)
							.padding(.horizontal)
							.padding(.bottom, 11.0)
					}
					.background(ColorManager.cardBackground)
					.frame(maxWidth: 400.0)
					.cornerRadius(20)
					.padding(.horizontal)
					.padding(.bottom)
				}
				.navigationTitle("What's new")
				.navigationBarTitleDisplayMode(.inline)
				.onAppear{ self.loadData() }
				.frame(maxWidth: 500)
			}
		}
	}
}

struct NewsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewsScreen()
    }
}
