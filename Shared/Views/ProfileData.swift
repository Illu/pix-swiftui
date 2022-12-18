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
import AlertToast

struct ProfileData: View {
	
	// must be one or the other
	var userRef: DocumentReference?
	var userId: String?

	var isCurrentSessionProfile = false
	
	@EnvironmentObject var app: AppStore
	@EnvironmentObject var session: SessionStore
	
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
		let docRef = (userId != nil) ? self.db.collection("Users").document(userId!) : userRef
		docRef!.getDocument { document, error in
			if let error = error as NSError? {
				print ("error: \(error.localizedDescription)")
			}
			else {
				if let document = document {
					do {
						self.userData = try document.data(as: UserData.self)
						loadUserBadges()
						if (userPosts.count == 0) {
							loadUserPosts()
						}
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
			.whereField("user.id", isEqualTo: userData?.id)
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
	
	func deletePost (id: String) {
		self.db.collection("Posts")
			.document(id)
			.delete() { err in
				if let err = err {
					app.showToast(toast: AlertToast(type: .systemImage("exclamationmark.triangle", Color.orange), subTitle: "There was an error while trying to delete your post"))
					print("Error removing document: \(err)")
				} else {
					app.showToast(toast: AlertToast(type: .complete(ColorManager.success), subTitle: "Post removed"))
					print("Document successfully removed!")
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
//						Text(isCurrentSessionProfile ? "Your posts" : "Posts").font(.title2)
						if (session.isAdmin) {
							Text("🔨 ADMIN MODE 👀").font(.title2)
						}
						if (userPosts.count > 0) {
							LazyVGrid(columns: columns, spacing: 20) {
								ForEach(userPosts, id: \.self.id) { post in
									Menu {
										Button(action: {app.showCommentsSheet(postId: post.id!, authorId: userId != nil ? userId! : userRef!.documentID)}) { HStack {Image(systemName: "text.bubble"); Text("View comments"); Spacer()  }}
										if (isCurrentSessionProfile || session.isAdmin) {
											Menu("Delete Post...") {
												Button(action: {
													deletePost(id: post.id!)
												}) { HStack {Text("Confirm"); Spacer(); Image(systemName: "trash") }}
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
	}.onAppear {
		loadUserData()
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

//struct ProfileData_Previews: PreviewProvider {
//	static var previews: some View {
//		ProfileData(userRef: "")
//	}
//}
