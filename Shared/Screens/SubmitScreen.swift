//
//  SubmitScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-23.
//

import SwiftUI
import FirebaseFirestore
import AlertToast

struct SubmitScreen: View {
	var postData: PostData
	
	@EnvironmentObject var session: SessionStore
	@EnvironmentObject var challenge: ChallengeStore
	@EnvironmentObject var app: AppStore
	
	@Environment(\.presentationMode) var mode: Binding<PresentationMode>
	
	@State var description: String = ""
	@State var addChallengeTag = false
	@State var screenWidth: CGFloat = 0
	@State var state = States.IDLE
	
	var db = Firestore.firestore()

	func submitPost (userRef: DocumentReference, postData: PostData, description: String, tag: String?) {
		if (state != States.LOADING) {
			state = States.LOADING
			db.collection("Posts").addDocument(data: [
				"userRef": userRef,
				"user": [
					"avatar": "",
					"id": userRef.documentID,
					"displayName": ""
				],
				"data": [
					"backgroundColor": postData.backgroundColor,
					"pixels": postData.pixels.compactMap { ["color": $0.color] }
				],
				"desc": description,
				"likes": [],
				"likesCount": 0,
				"tag": tag ?? "",
				"timestamp": Int(Date.currentTimeStamp)
			]) { err in
				if err != nil {
					self.state = States.ERROR
					app.showToast(toast: AlertToast(type: .error(ColorManager.error), subTitle: "Could not post your art 😥"))
			   } else {
				   self.state = States.SUCCESS
				   if (tag != nil) {
					   db.collection("Users").document(session.session!.uid).updateData([
						"badges": FieldValue.arrayUnion([challenge.currentMonth.prefix(3)]),
					  ])
					   app.showToast(toast: AlertToast(type: .systemImage("rosette", ColorManager.accent), title: "Post submitted 🎉", subTitle: "Profile badge acquired"))
				   } else {
					   app.showToast(toast: AlertToast(type: .complete(ColorManager.success), title: "Post submitted! 🎉"))
				   }
				   self.mode.wrappedValue.dismiss()
				   app.resetEditor()
			   }
			}
		}
	}
	
	var body: some View {
		VStack {
			ScrollView {
				Spacer()
				PixelArt(data: postData, pixelSize: screenWidth / ART_SIZE)
					.frame(width: screenWidth, height: screenWidth)
				GeometryReader { geometry in
					HStack{}.onAppear{
						var width = geometry.size.width
						if (width > 400) {
							width = 400
						}
						width = width - 32
						self.screenWidth = width
					}
				}
				Spacer()
				VStack {
					VStack(alignment: .leading) {
						Text("A quick word about your masterpiece ?")
							.fontWeight(.semibold)
						TextField("Add a description...", text: $description)
							.submitLabel(.continue)
							.onSubmit {
								// todo
							}
							.textFieldStyle(RoundedBorderTextFieldStyle())
					}.padding(16)
					HStack {
						Text("I'm participating in this month challenge (\(challenge.challengeTitle))").fontWeight(.semibold)
						Spacer()
						Toggle("", isOn: $addChallengeTag).labelsHidden()
					}
					.padding(16)
				}
				.background(ColorManager.screenBackground)
				.cornerRadius(20)
				.padding(.horizontal, 16)
				.padding(.vertical, 16)
				.toolbar {
					Button(action: {
						self.submitPost(userRef: db.document("Users/\(self.session.session?.uid ?? "")"), postData: postData, description: description, tag: addChallengeTag ? challenge.challengeId : nil)
					}) {
						HStack {
							if (state == States.LOADING) {
								ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).padding(.horizontal, 20).padding(.vertical, 5)
							} else {
								Text("Publish").foregroundColor(.white).padding(.horizontal, 20).padding(.vertical, 5)
							}
						}.background(RoundedRectangle(cornerRadius: 6)).padding(4)
					}
				}
			}
		}.onAppear {
			challenge.loadChallengeData()
		}
	}
}
