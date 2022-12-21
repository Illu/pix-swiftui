//
//  ChallengeStore.swift
//  pix
//
//  Created by Maxime Nory on 2022-04-02.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseStorage

class ChallengeStore: ObservableObject {
		
	private var db = Firestore.firestore()
	@Published var challengeTitle: String = ""
	@Published var challengeImageURL: URL? = nil
	@Published var challengeId: String = ""
	@Published var currentMonth: String = ""

	func getCurrentMonth() -> String {
		let now = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "LLLL"
		dateFormatter.locale = Locale(identifier: "EN-en")
		self.currentMonth = dateFormatter.string(from: now)
		return dateFormatter.string(from: now)
	}
	
	func getAllChallenges() async -> [Challenge] {
		do {
			let querySnapshot = try await Firestore.firestore().collection("Challenges").getDocuments()
			var result = [Challenge]()
			try querySnapshot.documents.forEach { challenge in
				let challengeData = try challenge.data(as: Challenge.self)
				result.append(Challenge(id: challengeData?.id ?? "", title: challengeData?.title ?? "Error"))
			}
			return result
		} catch {
			print("Error while retrieving challenge data")
		}
		return []
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
						self.challengeId = challengeData?.id ?? ""
					} catch {
						print("error while retrieving challenge data")
					}
				}
			}
		}
	}
}
