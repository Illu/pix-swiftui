//
//  CurrentChallengeCard.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-03.
//

import SwiftUI
import CachedAsyncImage

struct CurrentChallengeCard: View {
    
	@EnvironmentObject var challenge: ChallengeStore

    var body: some View {
        ZStack {
			CachedAsyncImage(url: challenge.challengeImageURL)
			VStack {}
				.frame(maxWidth: 350, maxHeight: .infinity)
				.background(
					LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
						.padding(0)
				)
			VStack(alignment: .leading) {
				Text("\(challenge.currentMonth) Challenge").fontWeight(.semibold)
				HStack {
					Text("\(challenge.challengeTitle)").foregroundColor(.black).padding(.horizontal, 20).padding(.vertical, 5)
				}.background(RoundedRectangle(cornerRadius: 6)).padding(4)
				Text("Participate in our challenge to win this month unique badge and get a chance to enter the hall of fame !")
			}
			.padding(15)
			.foregroundColor(.white)
			.frame(maxWidth: 350)
        }
		.frame(maxWidth: 350)
		.cornerRadius(8)
		.clipped()
		.padding(.bottom, 12)
		.onAppear(perform: challenge.loadChallengeData)
    }
}

struct CurrentChallengeCard_Previews: PreviewProvider {
    static var previews: some View {
		List {
			CurrentChallengeCard()
		}
    }
}
