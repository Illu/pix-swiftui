//
//  AchievementsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-12-20.
//

import SwiftUI
import CachedAsyncImage

struct AchievementsScreen: View {
	@EnvironmentObject var profile: ProfileStore
	@EnvironmentObject var challenge: ChallengeStore
	
	@State var challenges = [Challenge]()
	
	func loadAllChallenges () {
		Task {
			self.challenges = await challenge.getAllChallenges()
		}
	}
	
	func getAvailableChallenges () -> [Challenge] {
		return challenges.filter { chal in
			return profile.badges.first(where: { item in
				return item.id.lowercased() == chal.id.lowercased()
			}) == nil
		}
	}
	
	var body: some View {
		VStack {
			List {
				if (profile.badges.count > 0) {
					Section(header: Text("Unlocked")) {
						ForEach(profile.badges, id: \.self) { badge in
							HStack {
								CachedAsyncImage(
									url: badge.imageUrl,
									content: { image in
										image.resizable()
											.aspectRatio(contentMode: .fit)
											.frame(width: 40, height: 40)
											.clipShape(Circle())
									},
									placeholder: {
										ProgressView()
											.frame(width: 40, height: 40)
									}
								)
								Text(challenges.first(where: { item in
									return item.id.lowercased() == badge.id.lowercased()
								})?.title ?? "Unknown")
								.padding(.leading)
							}
						}
					}
				}
				if (getAvailableChallenges().count > 0) {
					Section(header: Text("Available")) {
						ForEach(getAvailableChallenges()) { challenge in
							HStack {
								Image(systemName: "questionmark.circle")
									.font(.system(size: 38))
									.foregroundColor(ColorManager.secondaryText)
								Text(challenge.title)
									.padding(.leading)
							}
						}
					}
				}
			}
		}
		.navigationTitle("Achievements")
		.onAppear(perform: loadAllChallenges)
	}
}

struct AchievementsScreen_Previews: PreviewProvider {
	static var previews: some View {
		AchievementsScreen()
	}
}
