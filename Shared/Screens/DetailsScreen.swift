//
//  DetailsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-12-16.
//

import SwiftUI
import FirebaseFirestore

struct DetailsScreen: View {
	
	var postId: String

	@State var postData: Post? = nil
	@State var state = States.IDLE
	@State var screenWidth: CGFloat = 0
	@State var comments: [Comment] = []

	var db = Firestore.firestore()
	
	@EnvironmentObject var session: SessionStore

	func generateReadableDate (time: Int) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM d, yyyy"
		return formatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(time / 1000)) as Date)
	}

	func loadPostData () {
		self.state = States.LOADING
		let docRef = self.db.collection("Posts").document(postId)
		docRef.getDocument { document, error in
			if let error = error as NSError? {
				print ("error: \(error.localizedDescription)")
				self.state = States.SUCCESS
			}
			else {
				if let document = document {
					do {
						let post = try document.data(as: Post.self)
						self.postData = post!
						self.state = States.SUCCESS
					}
					catch {
						print(error)
						self.state = States.ERROR
					}
				}
			}
		}
		self.loadComments()
	}
	
	func loadComments () {
		self.state = States.LOADING
		let docRef = self.db.collection("Posts").document(postId)
		docRef.getDocument { document, error in
			if let error = error as NSError? {
				print ("error: \(error.localizedDescription)")
				self.state = States.SUCCESS
			}
			else {
				if let document = document {
					do {
						let post = try document.data(as: Post.self)
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
		let updateReference = self.db.collection("Posts").document(postId)
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
			ColorManager.screenBackground
			ScrollView{
				VStack {
					GeometryReader { geometry in
						HStack{}.onAppear {
							var width = geometry.size.width
							if (width > 400) {
								width = 400
							}
							width = width - (32 + 16)
							self.screenWidth = width
						}
					}
					VStack {
						if (self.postData != nil) {
							VStack(alignment: .leading) {
								Spacer()
								PixelArt(data: self.postData!.data, pixelSize: screenWidth / ART_SIZE)
									.frame(width: screenWidth + 16, height: screenWidth)
									.padding(.bottom, 5)
								Spacer()
								if (self.postData?.likesCount ?? 0 > 0) {
									HStack {
										Image(systemName: "heart.fill")
											.foregroundColor(.red)
											.font(.system(size: 20))
										Text("Liked by \(self.postData!.likes.count) user\(self.postData!.likes.count > 1 ? "s" : "")")
											.font(.system(size: 14))
											.foregroundColor(ColorManager.primaryText)
									}
									.padding(.bottom, 5)
								}
								if (self.postData!.desc.count > 0) {
									Text(self.postData!.desc)
										.font(.system(size: 14))
										.foregroundColor(ColorManager.primaryText)
										.multilineTextAlignment(.leading)
										.fixedSize(horizontal: false, vertical: true)
								}
								Text(generateReadableDate(time: self.postData!.timestamp))
									.fontWeight(.light)
									.font(.footnote)
									.foregroundColor(ColorManager.secondaryText)
							}
							.padding(.horizontal)
							.padding(.vertical)
							.background(ColorManager.cardBackground)
							.cornerRadius(20.0)
							
							VStack {
								CommentTextInput(postId: postId, news: false, authorId: self.postData!.userRef.documentID, commentsCount: comments.count, loadData: self.loadComments)
									.padding(.top)
									.padding(.horizontal)
									.padding(.bottom, 11.0)
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
							}
							.background(ColorManager.cardBackground)
							.cornerRadius(20)
						}
					}
				}
				.padding(.horizontal)
				.padding(.bottom)
			}
			.refreshable(action: {self.loadPostData()})
			.navigationTitle("Post details")
			.onAppear(perform: self.loadPostData)
		}
    }
}
