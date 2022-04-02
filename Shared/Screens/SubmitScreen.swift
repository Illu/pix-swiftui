//
//  SubmitScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-23.
//

import SwiftUI
import FirebaseFirestore

struct SubmitScreen: View {
	var postData: PostData
	
	@EnvironmentObject var session: SessionStore
	@EnvironmentObject var challenge: ChallengeStore
	@ObservedObject private var viewModel = PublishViewModel()

	@State var description: String = ""
	@State var addChallengeTag = false
	
	var db = Firestore.firestore()

	var body: some View {
		VStack {
			Spacer()
			PixelArt(data: postData)
			Spacer()
			VStack(alignment: .leading) {
				Text("A quick word about your masterpiece ?")
					.fontWeight(.semibold)
				TextField("Add a description...", text: $description)
					.padding(.horizontal, 16)
					.padding(.vertical, 10)
					.submitLabel(.continue)
					.onSubmit {
						// todo
					}
					.overlay(
						RoundedRectangle(cornerRadius: 4.0)
							.stroke(ColorManager.inputBackground, lineWidth: 1)
					)
			}.padding(16)
			HStack {
				Text("I'm participating in this month challenge (\(challenge.challengeTitle))").fontWeight(.semibold)
				Spacer()
				Toggle("", isOn: $addChallengeTag).labelsHidden()
			}
			.padding(16)
			.toolbar {
				Button(action: {
					viewModel.submitPost(userRef: db.document("Users/\(self.session.session?.uid ?? "")"), postData: postData, description: description, tag: addChallengeTag ? challenge.challengeId : nil)
				}) {
					HStack {
						if (viewModel.state == States.LOADING) {
							ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).padding(.horizontal, 20).padding(.vertical, 5)
						} else {
							Text("Publish").foregroundColor(.white).padding(.horizontal, 20).padding(.vertical, 5)
						}
					}.background(RoundedRectangle(cornerRadius: 6)).padding(4)
				}
				
			}
		}.onAppear {
			challenge.loadChallengeData()
		}
	}
}
