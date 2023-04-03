//
//  CommentsView.swift
//  pix (iOS)
//
//  Created by Maxime Nory on 2023-01-05.
//

import SwiftUI

struct CommentsView: View {
	
	@EnvironmentObject var session: SessionStore

	@StateObject private var viewModel: CommentsViewModel
	
	init(postId: String, authorId: String?, news: Bool = false) {
		_viewModel = StateObject(wrappedValue: CommentsViewModel(postId: postId, authorId: authorId, news: news))
	}
	
	func onTapDeleteComment (comment: Comment) {
		Task {
			await viewModel.deleteComment(comment: comment)
		}
	}
	
	var body: some View {
		VStack {
			CommentTextInput(addComment: viewModel.addComment, placeholder: viewModel.getPlaceholderText(session: session.session), authorId: viewModel.authorId)
				.padding(.top)
				.padding(.horizontal)
				.padding(.bottom, 11.0)
			if (viewModel.state == States.LOADING) {
				ProgressView()
			} else {
				ForEach(viewModel.comments, id: \.self) { comment in
					CommentView(comment: comment, userRef: comment.userRef)
						.padding(.horizontal)
						.contextMenu {
							Button(action: { UIPasteboard.general.string = comment.text }) { HStack {Text("Copy comment"); Spacer(); Image(systemName: "doc.on.doc")}}
							if (session.isAdmin || viewModel.isCommentFromCurrentUser(comment: comment, session: session.session) ) {
								Button(action: { onTapDeleteComment(comment: comment) }) { HStack {Text("Delete comment"); Spacer(); Image(systemName: "trash")}}
							}
						}
				}
			}
		}
		.background(ColorManager.cardBackground)
		.frame(maxWidth: 400.0)
		.cornerRadius(20)
		.onAppear{
			viewModel.loadData()
		}
	}
}

struct CommentsView_Previews: PreviewProvider {
	static var previews: some View {
		CommentsView(postId: "1234", authorId: nil)
	}
}
