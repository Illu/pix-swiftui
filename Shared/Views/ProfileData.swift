//
//  ProfileData.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-02.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import CachedAsyncImage

struct ProfileData: View {
	
	var userId: String
	var isCurrentSessionProfile = false
	
	@EnvironmentObject var app: AppStore
	
	@State var userData: UserData? = nil
	@State var badgesUrls = [URL]()
	@State var userPosts = [Post]()
	
	var db = Firestore.firestore()
	
	func loadUserBadges () {
		let badges = userData?.badges ?? []
		self.badgesUrls = []
		badges.forEach { badge in
			Storage.storage()
				.reference(withPath: "badges/\(badge.lowercased()).png")
				.downloadURL {url, error in
					if let error = error {
						print("Error retriving challenge image URL: \(error)")
					} else {
						self.badgesUrls.append(url!)
					}
				}
		}
	}
	
	func loadUserData () {
		let docRef = self.db.collection("Users").document(userId)
		docRef.getDocument { document, error in
			if let error = error as NSError? {
				print ("error: \(error.localizedDescription)")
			}
			else {
				if let document = document {
					do {
						self.userData = try document.data(as: UserData.self)
						loadUserBadges()
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
			.whereField("user.id", isEqualTo: userId)
			.order(by: "timestamp", descending: true)
			.addSnapshotListener { (querySnapshot, error ) in
				guard let documents = querySnapshot?.documents else {
					print("User has no posts")
					self.userPosts = []
					return
				}
				
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
	
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	var body: some View {
		ScrollView {
			VStack {
				if (userData == nil) {
					ProgressView()
				} else {
					VStack(alignment: .leading){
						HStack {
							RoundedAvatar(name: userData?.avatar, size: 120)
							VStack(alignment: .leading) {
								Spacer()
								Text(userData?.displayName ?? "Username Error 😭")
									.fontWeight(.bold)
								Text("\($userPosts.count) Post\($userPosts.count != 1 ? "s" : "")")
								ScrollView(.horizontal) {
									HStack {
										ForEach(badgesUrls, id: \.self) { badgeUrl in
											CachedAsyncImage(
												url: badgeUrl,
												content: { image in
													image.resizable()
														.aspectRatio(contentMode: .fit)
														.frame(width: 30, height: 30)
														.clipShape(Circle())
												},
												placeholder: {
													ProgressView()
														.frame(width: 30, height: 30)
												}
											)
										}
									}
								}
								Spacer()
							}
						}.padding(.bottom, 10)
						Text(isCurrentSessionProfile ? "Your posts" : "Posts").font(.title2)
						if (userPosts.count > 0) {
							LazyVGrid(columns: columns, spacing: 20) {
								ForEach(userPosts, id: \.self.id) { post in
									Menu {
										Button(action: {app.showCommentsSheet(postId: post.id!)}) { HStack {Image(systemName: "text.bubble"); Text("View comments"); Spacer()  }}
										if (isCurrentSessionProfile) {
											Menu("Delete Post...") {
												Button(action: {}) { HStack {Text("Confirm"); Spacer(); Image(systemName: "trash") }}
												Button(action: {}) { HStack {Text("Cancel"); Spacer(); Image(systemName: "arrow.uturn.left") }}
											}
										}
										
									} label: {
										PixelArt(data: post.data)
											.cornerRadius(4)
									}
								}
							}
						} else {
							Empty()
						}
					}.padding(16)
				}
		}
	}.onAppear{
		loadUserData()
		if (userPosts.count == 0) {
			loadUserPosts()
		}
	}
	.navigationTitle(isCurrentSessionProfile ? "Your Profile" : "Profile")
	.navigationBarTitleDisplayMode(.inline)
	.toolbar {
		if (isCurrentSessionProfile) {
			NavigationLink(destination: EditProfile()) {
				Image(systemName: "square.and.pencil")
			}
		}
	}
}
}

struct ProfileData_Previews: PreviewProvider {
	static var previews: some View {
		ProfileData(userId: "")
	}
}
