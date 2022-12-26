//
//  ProfileStore.swift
//  pix
//
//  Created by Maxime Nory on 2022-12-19.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ProfileStore: ObservableObject {
	
	var db = Firestore.firestore()
	
	@Published var state = States.IDLE
	@Published var userData: UserData? = nil
	@Published var badges = [Badge]()
	@Published var userPosts = [Post]()
	
	func loadUserBadges () {
		let badges = userData?.badges ?? []
		self.badges = []
		badges.forEach { badge in
			Storage.storage()
				.reference(withPath: "badges/\(badge.lowercased()).png")
				.downloadURL {url, error in
					if let error = error {
						print("Error retriving challenge image URL: \(error)")
					} else {
						self.badges.append(Badge(imageUrl: url!, id: badge.lowercased()))
					}
				}
		}
	}
	
	func loadUserData (userId: String?, userRef: DocumentReference?) {
		let docRef = (userId != nil) ? self.db.collection("Users").document(userId!) : userRef
		docRef!.getDocument { document, error in
			if let error = error as NSError? {
				print ("error: \(error.localizedDescription)")
			}
			else {
				if let document = document {
					do {
						self.userData = try document.data(as: UserData.self)
						self.loadUserBadges()
						self.loadUserPosts()
					}
					catch {
						print(error)
					}
				}
			}
		}
	}
	
	func loadUserPosts () {
		self.userPosts = []
		self.db.collection("Posts")
			.whereField("user.id", isEqualTo: self.userData?.id ?? "")
			.order(by: "timestamp", descending: true)
			.addSnapshotListener { (querySnapshot, error ) in
				guard let documents = querySnapshot?.documents else {
					print("User has no posts")
					self.userPosts = []
					return
				}
				self.userPosts = []
				documents.forEach { (queryDocumentSnapshot) in
					do {
						let post = try queryDocumentSnapshot.data(as: Post.self)
						self.userPosts.append(post!)
					}
					catch {
						print(error)
						self.userPosts = []
					}
				}
			}
	}
	
	func deletePost (id: String) async throws -> Void {
		try await self.db.collection("Posts")
			.document(id)
			.delete()
	}
	
	func clear () {
		self.userData = nil
		self.userPosts = []
	}
}
