//
//  AboutScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-09.
//

import SwiftUI
import FirebaseFirestore
import AlertToast

struct AboutScreen: View {
	
	private var db = Firestore.firestore()
	@EnvironmentObject var session: SessionStore
	@EnvironmentObject var app: AppStore

	func checkRights () {
		db.collection("Admins").getDocuments() { (querySnapshot, error ) in
			guard let documents = querySnapshot?.documents else {
				print("No documents found")
				return
			}
			documents.forEach { (queryDocumentSnapshot) in
				do {
					let user = try queryDocumentSnapshot.data(as: Admin.self)
					if (user?.id == session.session?.uid ?? "??" && !session.isAdmin) {
						session.enableAdmin()
						app.showToast(toast: AlertToast(type: .systemImage("hammer", .red), title: "Welcome back 🤖", subTitle: "Your hammer is ready"))
					}
				}
				catch {
					print(error)
				}
			}
		}
	}
	
	var body: some View {
		VStack {
			List {
				HStack {
					Spacer()
					Image("pix")
						.resizable()
						.frame(width: 100, height: 100)
						.cornerRadius(20)
					VStack(alignment: .leading) {
						Text("Pix \(Bundle.main.releaseVersionNumber ?? "(Unknown version 🥸)")").fontWeight(.semibold)
						Text("by Maxime Nory").foregroundColor(ColorManager.secondaryText)
					}
					Spacer()
				}.listRowBackground(Color.clear)
				Section ("What is Pix ?") {
					Text("Pix is an online pixel art community. Share your creations with everyone to contribute to the App! If you have any questions or suggestion, feel free to contact me, I'll be glad to hear from you!")
				}
				Section ("Privacy policy") {
					Link(destination: URL(string: "https://maximenory.com/pix")!) {
						Text("Tap here to open our privacy policy informations using your default web browser").foregroundColor(ColorManager.primaryText)
					}
				}
			}
		}.onAppear(perform: checkRights)
	}
}

struct AboutScreen_Previews: PreviewProvider {
	static var previews: some View {
		AboutScreen()
	}
}
