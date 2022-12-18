//
//  CommentsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-01.
//

import SwiftUI
import FirebaseFirestore

struct CommentsScreen: View {
    
    var postId: String
	var authorId: String?
	var news = false
    
    @EnvironmentObject var session: SessionStore
    
    @State var comments: [Comment] = []
    @State var state: States = States.IDLE
    
	var db = Firestore.firestore()
    
    func loadData () {
        self.state = States.LOADING
		let docRef = self.db.collection(news ? "News" : "Posts").document(postId)
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print ("error: \(error.localizedDescription)")
                self.state = States.SUCCESS
            }
            else {
                if let document = document {
					if (news) {
						do {
							let post = try document.data(as: News.self)
							self.comments = post?.comments ?? []
							self.state = States.SUCCESS
						}
						catch {
							print(error)
							self.state = States.ERROR
						}
					} else {
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
    }
	
	func deleteComment (comment: Comment) {
		let updateReference = self.db.collection(news ? "News" : "Posts").document(postId)
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
		self.loadData()
	}
	
	func isCommentFromCurrentUser (comment: Comment) -> Bool {
		if (session.session != nil) {
			return db.document("Users/\(self.session.session?.uid ?? "")") == comment.userRef
		}
		return false
	}
    
    var body: some View {
        VStack {
            if (state == States.LOADING) {
                ProgressView()
            }
            if ($comments.count == 0 && state != States.LOADING) {
                Spacer()
                Empty()
                Spacer()
            } else {
                ScrollView {
					VStack {
						ForEach(comments, id: \.self) { comment in
							CommentView(comment: comment, userRef: comment.userRef)
								.padding(.horizontal, 16)
								.contextMenu {
									Button(action: { UIPasteboard.general.string = comment.text }) { HStack {Text("Copy comment"); Spacer(); Image(systemName: "doc.on.doc")}}
									if (session.isAdmin || isCommentFromCurrentUser(comment: comment) ) {
										Button(action: { deleteComment(comment: comment) }) { HStack {Text("Delete comment"); Spacer(); Image(systemName: "trash")}}
									}
								}
						}
					}
					.background(ColorManager.cardBackground)
					.cornerRadius(20.0)
					.padding(.all)
                }
            }
			CommentTextInput(postId: postId, news: news, authorId: authorId, commentsCount: comments.count, loadData: self.loadData)
				.padding(.horizontal, 16)
        }
		.background(ColorManager.screenBackground)
		.navigationTitle(news ? "What's new" : "Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadData()
        }
    }
}

struct CommentsScreen_Previews: PreviewProvider {
    static var previews: some View {
		CommentsScreen(postId: "")
    }
}
