//
//  DetailsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-12-16.
//

import SwiftUI
import FirebaseFirestore
import AlertToast

struct DetailsScreen: View {
	
	var postId: String

	@State var postData: Post? = nil
	@State var state = States.IDLE
	@State var screenWidth: CGFloat = 0

	var db = Firestore.firestore()
	
	@EnvironmentObject var session: SessionStore
	@EnvironmentObject var app: AppStore
	
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
						if (post != nil) {
							self.postData = post!
							self.state = States.SUCCESS
						} else {
							self.state = States.ERROR
							app.showToast(toast: AlertToast(type: .systemImage("exclamationmark.triangle", Color.red), subTitle: "This post doesn't exist"))
						}
					}
					catch {
						print(error)
						self.state = States.ERROR
					}
				}
			}
		}
	}

    var body: some View {
		ZStack {
			ColorManager.screenBackground.ignoresSafeArea()
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
									.padding(.bottom, 2)
								}
								if (self.postData!.desc.count > 0) {
									Text(self.postData!.desc)
										.font(.system(size: 14))
										.foregroundColor(ColorManager.primaryText)
										.multilineTextAlignment(.leading)
										.fixedSize(horizontal: false, vertical: true)
										.padding(.bottom, 2)
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
							
							CommentsView(postId: postId, authorId: postData?.userRef.documentID)
//							VStack {
//								CommentTextInput(postId: postId, news: false, authorId: self.postData!.userRef.documentID, commentsCount: comments.comments.count, loadData: comments.loadData)
//									.padding(.top)
//									.padding(.horizontal)
//									.padding(.bottom, 11.0)
//								if (comments.state == States.LOADING) {
//									ProgressView()
//								} else {
//									ForEach(comments.comments, id: \.self) { comment in
//										CommentView(comment: comment, userRef: comment.userRef)
//											.padding(.horizontal)
//											.contextMenu {
//												Button(action: { UIPasteboard.general.string = comment.text }) { HStack {Text("Copy comment"); Spacer(); Image(systemName: "doc.on.doc")}}
//												if (session.isAdmin || isCommentFromCurrentUser(comment: comment) ) {
//													Button(action: { comments.deleteComment(comment: comment) }) { HStack {Text("Delete comment"); Spacer(); Image(systemName: "trash")}}
//												}
//											}
//									}
//								}
//							}
//							.background(ColorManager.cardBackground)
//							.frame(maxWidth: 400.0)
//							.cornerRadius(20)
						}
					}
				}
				.padding(.horizontal)
				.padding(.bottom)
			}
			.refreshable(action: {self.loadPostData()})
			.navigationTitle("Post details")
			.navigationBarTitleDisplayMode(.inline)
			.onAppear(perform: self.loadPostData)
		}
    }
}
