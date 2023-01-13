//
//  CommentTextInput.swift
//  pix
//
//  Created by Maxime Nory on 2022-12-17.
//

import SwiftUI
import FirebaseFirestore

struct CommentTextInput: View {

	var addComment: @MainActor (String, SessionUser, String?) -> Void
	var placeholder: String
	var authorId: String?
	
	var db = Firestore.firestore()

	@EnvironmentObject var session: SessionStore

	@State var currentComment: String = ""
	
	func onSendComment() {
		addComment(currentComment, session.session!, authorId)
		self.currentComment = "" //TODO: wait if addcomment succeeded before clearing comment input
	}
	
    var body: some View {
		HStack {
			TextField(placeholder, text: $currentComment)
				.padding(.horizontal, 16)
				.padding(.vertical, 10)
				.font(.system(size: 16))
				.submitLabel(.send)
				.onSubmit {
					onSendComment()
				}
				.disabled(session.session == nil)
			Image(systemName: "paperplane")
				.foregroundColor(currentComment != "" ? ColorManager.primaryText : ColorManager.secondaryText)
				.padding(.horizontal, 8)
				.disabled(session.session == nil || currentComment == "")
				.onTapGesture {
					onSendComment()
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
