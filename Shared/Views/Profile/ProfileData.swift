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
	
	@State var screenWidth = 0.0
	
	var POST_WIDTH = 105.0
	
	func getColumns () -> [GridItem] {
		let numberOfColumns = screenWidth / (POST_WIDTH + 8)
		return [GridItem](repeating: GridItem(.flexible()), count: Int(numberOfColumns))
	}
	
	func getBadgeCount () -> Int {
		return (profile.userData?.badges ?? []).count
	}
	
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
		ZStack {
			ColorManager.screenBackground.ignoresSafeArea()
			GeometryReader { geometry in
				HStack{}.onAppear{ self.screenWidth = geometry.size.width }
			}
			ScrollView {
				VStack {
					if (profile.userData == nil) {
						ProgressView()
					} else {
						VStack(alignment: .leading){
							HStack {
								HStack {
									RoundedAvatar(name: profile.userData?.avatar, size: 100)
									VStack(alignment: .leading) {
										Spacer()
										Text(profile.userData?.displayName ?? "Username Error 😭")
											.fontWeight(.bold)
										Text("\(profile.userPosts.count) Post\(profile.userPosts.count != 1 ? "s" : "")")
										Spacer()
									}
									.padding(.leading, 10)
									Spacer()
								}
								.padding()
							}
							.background(ColorManager.cardBackground)
							.cornerRadius(16)
							.padding(.bottom, 10)
							//Text(isCurrentSessionProfile ? "Your posts" : "Posts").font(.title2)
							if (session.isAdmin) {
								Text("🔨 ADMIN MODE 👀").font(.title2)
							}
							VStack(alignment: .leading) {
								HStack {
									ZStack {
										Circle()
											.stroke(ColorManager.screenBackground, lineWidth: 4)
											.frame(width: 40, height: 40)
										Circle()
											.trim(from: 0.0, to: (1 / 12) * CGFloat(getBadgeCount()))
											.stroke(.green, lineWidth: 4)
											.frame(width: 40, height: 40)
											.rotationEffect(Angle(degrees: -90))
										Text("\(getBadgeCount())/12")
											.font(.system(size: 14.0))
									}
									Text("Badges collected")
										.padding(.leading, 5.0)
								}
								.padding()
								HStack {
									NavigationLink(destination: AchievementsScreen(), label: {
										Text("View all achievements")
										Spacer()
										Image(systemName: "chevron.forward").foregroundColor(ColorManager.secondaryText)
									})
								}
								.padding(.horizontal)
								.padding(.bottom)
							}
							.background(ColorManager.cardBackground)
							.cornerRadius(16)
							.padding(.bottom, 10)
							if (profile.userPosts.count > 0) {
								LazyVGrid(columns: getColumns(), spacing: 20) {
									ForEach(profile.userPosts, id: \.self.id) { post in
										NavigationLink(destination: DetailsScreen(postId: post.id!)) {
											PixelArt(data: post.data, pixelSize: POST_WIDTH / ART_SIZE)
												.cornerRadius(4)
												.contextMenu {
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
}

//struct ProfileData_Previews: PreviewProvider {
//	static var previews: some View {
//		ProfileData(userRef: "")
//	}
//}
