//
//  CommentTextInput.swift
//  pix
//
//  Created by Maxime Nory on 2022-12-17.
//

import SwiftUI
import FirebaseFirestore

struct CommentTextInput: View {
	
	var postId: String
	var news: Bool
	var authorId: String?
	var commentsCount: Int
	var loadData: () -> Void
	
	var db = Firestore.firestore()

	@EnvironmentObject var session: SessionStore

	@State var currentComment: String = ""
	
	func getPlaceholderText () -> String {
		if (session.session == nil) {
			return "You must login to comment"
		}
		if (commentsCount == 0) {
			return "Add the first comment..."
		}
		return "Add your comment..."
	}
	
	func addComment () {
		if (self.currentComment != "" && session.session!.uid != "") {
			let textToSend = "\(self.currentComment)"
			self.currentComment = ""
			let updateReference = self.db.collection(news ? "News" : "Posts").document(postId)
			updateReference.updateData([
				"comments": FieldValue.arrayUnion(
					[
						["text": textToSend,
						 "timestamp": Int(Date.currentTimeStamp),
						 "userRef": db.document("Users/\(self.session.session?.uid ?? "")")
						]
					]
				)
			])
			loadData()
			
			// add to inbox for notification
			if (authorId != nil && authorId != session.session?.uid) {
				self.db.collection("Inboxes").document(authorId!).setData([
					"notifications": FieldValue.arrayUnion(
						[
							[
							 "type": NotificationType.COMMENT.rawValue,
							 "title": "\(self.session.session?.displayName ?? "Unknown") added a comment to your post",
							 "timestamp": Int(Date.currentTimeStamp),
							 "postId": postId,
							 "id": UUID().uuidString
							]
						]
					)
				], merge: true)
			}
		}
	}
	
    var body: some View {
		HStack {
			TextField(getPlaceholderText(), text: $currentComment)
				.padding(.horizontal, 16)
				.padding(.vertical, 10)
				.submitLabel(.send)
				.onSubmit {
					addComment()
				}
				.disabled(session.session == nil)
			Image(systemName: "paperplane")
				.foregroundColor(currentComment != "" ? ColorManager.primaryText : ColorManager.secondaryText)
				.padding(.horizontal, 8)
				.disabled(session.session == nil || currentComment == "")
				.onTapGesture {
					addComment()
				}
		}
		.background(ColorManager.inputBackground)
		.cornerRadius(4.0)
		.overlay(
			RoundedRectangle(cornerRadius: 4.0)
				.stroke(ColorManager.secondaryText, lineWidth: 1)
		)
		.padding(.bottom, 5.0)
    }
}
