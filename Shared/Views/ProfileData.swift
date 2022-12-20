//
//  ProfileData.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-02.
//

import SwiftUI
import CachedAsyncImage
import AlertToast
import FirebaseFirestore

struct ProfileData: View {
	
	// must be one or the other
	var userRef: DocumentReference?
	var userId: String?
	
	var isCurrentSessionProfile = false
	
	@EnvironmentObject var app: AppStore
	@EnvironmentObject var session: SessionStore
	@EnvironmentObject var profile: ProfileStore
	
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	func deletePost (id: String) {
		Task {
			do {
				try await profile.deletePost(id: id)
			} catch {
				app.showToast(toast: AlertToast(type: .systemImage("exclamationmark.triangle", Color.orange), subTitle: "There was an error while trying to delete your post"))
			}
			app.showToast(toast: AlertToast(type: .complete(ColorManager.success), subTitle: "Post removed"))
		}
	}
	
	var body: some View {
		ScrollView {
			VStack {
				if (profile.userData == nil) {
					ProgressView()
				} else {
					VStack(alignment: .leading){
						HStack {
							RoundedAvatar(name: profile.userData?.avatar, size: 120)
							VStack(alignment: .leading) {
								Spacer()
								Text(profile.userData?.displayName ?? "Username Error 😭")
									.fontWeight(.bold)
								Text("\(profile.userPosts.count) Post\(profile.userPosts.count != 1 ? "s" : "")")
								ScrollView(.horizontal) {
									HStack {
										ForEach(profile.badgesUrls, id: \.self) { badgeUrl in
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
						if (profile.userPosts.count > 0) {
							LazyVGrid(columns: columns, spacing: 20) {
								ForEach(profile.userPosts, id: \.self.id) { post in
									NavigationLink(destination: DetailsScreen(postId: post.id!)) {
										PixelArt(data: post.data)
											.cornerRadius(4)
											.contextMenu {
												Button(action: {app.showCommentsSheet(postId: post.id!, authorId: userId != nil ? userId! : userRef!.documentID)}) { HStack {Image(systemName: "text.bubble"); Text("View comments"); Spacer()  }}
												if (isCurrentSessionProfile || session.isAdmin) {
													Menu("Delete Post...") {
														Button(action: {
															deletePost(id: post.id!)
														}) { HStack {Text("Confirm"); Spacer(); Image(systemName: "trash") }}
														Button(action: {}) { HStack {Text("Cancel"); Spacer(); Image(systemName: "arrow.uturn.left") }}
													}
												}
											}
									}
								}
							}
						} else {
							Empty()
						}
					}.padding(16)
				}
			}
		}
		.refreshable(action: { profile.loadUserData(userId: userId, userRef: userRef) })
		.onAppear {
			if ((userId != nil && profile.userData?.id != userId) || (userRef != nil && profile.userData?.id != userRef?.documentID)) {
				profile.clear()
				profile.loadUserData(userId: userId, userRef: userRef)
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

//struct ProfileData_Previews: PreviewProvider {
//	static var previews: some View {
//		ProfileData(userRef: "")
//	}
//}
