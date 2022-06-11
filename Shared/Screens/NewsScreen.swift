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
		ZStack {
			ColorManager.screenBackground
			ScrollView {
				VStack {
					if (state == States.LOADING) {
						ProgressView()
					} else if (newsData == nil) {
						Text("Something went wrong while retrieving the latest news 😥").padding(.bottom, 30)
						Button(action: {self.loadData()}) {
							LargeButton(title: "Try again", withBackground: true)
						}
					}
					if (newsData != nil) {
						VStack {
							Image("koala").padding(.vertical, 30)
							Text("\(newsData!.title)").fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).padding(16).font(.title)
							ForEach(newsData!.desc, id: \.self) { paragraph in
								Text("\(paragraph)").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding(16).fixedSize(horizontal: false, vertical: true)
							}
							Spacer()
	//						NavigationLink(destination: RequestNewFeatureScreen()) {
	//							Text("Help improve the App")
	//						}
							Spacer()
						}
					}
					Text("Comments").fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top], 16).font(.title)
					CommentsScreen(postId: "current", news: true)
				}
				.navigationTitle("What's new")
				.navigationBarTitleDisplayMode(.inline)
				.onAppear{ self.loadData() }
				.frame(maxWidth: 500)
			}
		}
	}
}

struct NewsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewsScreen()
    }
}
