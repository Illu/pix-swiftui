//
//  NewsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-07.
//

import SwiftUI
import FirebaseFirestore

struct NewsScreen: View {
	
	@State var newsData: News? = nil
	@State var state: States = States.IDLE
	
	var db = Firestore.firestore()
	
	func loadData () {
		self.state = States.LOADING
		let docRef = self.db.collection("News").document("current")
		docRef.getDocument { document, error in
			if let error = error as NSError? {
				print ("error: \(error.localizedDescription)")
				self.state = States.ERROR
			}
			else {
				if let document = document {
					do {
						let newsData = try document.data(as: News.self)
						self.newsData = newsData ?? nil
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

	
    var body: some View {
        VStack {
			if (state == States.LOADING) {
				ProgressView()
			} else if (newsData == nil) {
				Text("Something went wrong while retrieving the latest news 😥")
			}
			if (newsData != nil) {
				Text("\(newsData!.title)")
				Text("\(newsData!.desc)")
			}
		}
		.navigationTitle("What's new")
		.onAppear{self.loadData()}
    }
}

struct NewsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewsScreen()
    }
}
