//
//  CurrentChallengeCard.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-03.
//

import SwiftUI
import FirebaseStorage
import CachedAsyncImage
import FirebaseFirestore

struct CurrentChallengeCard: View {
    
	@State var challengeTitle: String = ""
    @State var challengeImageURL: URL? = nil
    
	func getCurrentMonth() -> String {
		let now = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "LLLL"
		dateFormatter.locale = Locale(identifier: "EN-en")
		return dateFormatter.string(from: now)
	}
	
    func loadChallengeData() {
        let currentMonth = getCurrentMonth().lowercased()
        Storage.storage()
            .reference(withPath: "challenges/\(currentMonth).png")
            .downloadURL {url, error in
                if let error = error {
                    print("Error retriving challenge image URL: \(error)")
                } else {
                    self.challengeImageURL = url
                }
            }
		
		let currentMonthId = getCurrentMonth().prefix(3)
		Firestore.firestore().collection("Challenges").getDocuments() { (querySnapshot, error ) in
			guard let challenges = querySnapshot?.documents else {
			   print("No challenges in Challenges :(")
			   return
			}
			challenges.forEach { challenge in
				if (challenge.documentID == currentMonthId) {
					do {
						let challengeData = try challenge.data(as: Challenge.self)
						self.challengeTitle = challengeData?.title ?? "Error"
					} catch {
						print("error while retrieving challenge data")
					}
				}
			}
		}
    }
    
    var body: some View {
        ZStack {
            CachedAsyncImage(url: challengeImageURL)
			VStack {
				Text("\(getCurrentMonth()) Challenge")
				Text("\(challengeTitle)")
				Text("Participate in our challenge to win this month unique badge and get a chance to enter the hall of fame !")
				Button("Create your entry now!") {}
			}
        }.onAppear(perform: loadChallengeData)
    }
}

struct CurrentChallengeCard_Previews: PreviewProvider {
    static var previews: some View {
        CurrentChallengeCard()
    }
}
