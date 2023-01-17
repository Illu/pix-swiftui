//
//  CommentsViewModel.swift
//  pix (iOS)
//
//  Created by Maxime Nory on 2023-01-04.
//

import Foundation
import FirebaseFirestore

extension CommentsView {
	/// Allows loading, sending, deleting, adding a notification for comments on a Post or a News.
	@MainActor class CommentsViewModel: ObservableObject {

		var postId: String
		var authorId: String?
		var news: Bool
		
		init(postId: String, authorId: String?, news: Bool = false) {
			self.postId = postId
			self.authorId = authorId
			self.news = news
		}
		
		@Published var state: States = States.IDLE
		@Published var comments: [Comment] = []
		
		private var db = Firestore.firestore()
		
		private func sortComments (comments: [Comment]) -> [Comment] {
			return comments.sorted { $0.timestamp > $1.timestamp }
		}
		
		/// Loads the comments for the current postId. If we are in "news" mode (news = true), this call should use "current" as an ID
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
						if (self.news) {
							do {
								let post = try document.data(as: News.self)
								self.comments = self.sortComments(comments: post?.comments ?? [])
								self.state = States.SUCCESS
							}
							catch {
								print(error)
								self.state = States.ERROR
							}
						} else {
							do {
								let post = try document.data(as: Post.self)
								self.comments = self.sortComments(comments: post?.comments ?? [])
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
		
		func deleteComment (comment: Comment) async {
			let updateReference = self.db.collection(news ? "News" : "Posts").document(postId)
			do {
				try await updateReference.updateData([
					"comments": FieldValue.arrayRemove(
						[
							["text": comment.text,
							 "timestamp": comment.timestamp,
							 "userRef": comment.userRef
							]
						]
					)
				])
			} catch {
				print("error deleting comment")
			}
			// TODO: make this async / await
			self.loadData()
		}
		
		/// Returns the placeholder text used in the text input for adding a comment
		/// - Returns: The placeholder text String
		/// - Parameter session: The current user Session Object
		func getPlaceholderText (session: SessionUser?) -> String {
			if (session == nil) {
				return "You must login to comment"
			}
			if (self.comments.count == 0) {
				return "Add the first comment..."
			}
			return "Add your comment..."
		}
		
		func addComment (comment: String, session: SessionUser?, authorId: String?) {
			if (session!.uid != "") {
				let updateReference = self.db.collection(news ? "News" : "Posts").document(postId)
				updateReference.updateData([
					"comments": FieldValue.arrayUnion(
						[
							["text": comment,
							 "timestamp": Int(Date.currentTimeStamp),
							 "userRef": db.document("Users/\(session?.uid ?? "")")
							]
						]
					)
				])
				loadData()
				if (authorId != nil) {
					self.sendCommentNotification(authorId: authorId!, session: session)
				}
			}
		}
		
		func sendCommentNotification (authorId: String, session: SessionUser?) {
			if (authorId != session?.uid) {
				self.db.collection("Inboxes").document(authorId).setData([
					"notifications": FieldValue.arrayUnion(
						[
							[
							 "type": NotificationType.COMMENT.rawValue,
							 "title": "\(session?.displayName ?? "Unknown") added a comment to your post",
							 "timestamp": Int(Date.currentTimeStamp),
							 "postId": postId,
							 "id": UUID().uuidString
							]
						]
					)
				], merge: true)
			}
		}
		
		func isCommentFromCurrentUser (comment: Comment, session: SessionUser?) -> Bool {
			if (session != nil) {
				return db.document("Users/\(session?.uid ?? "")") == comment.userRef
			}
			return false
		}
	}
}
