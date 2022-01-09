//
//  ChallengesScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-30.
//

import SwiftUI

struct ChallengesScreen: View {
    
	@State var challenge: String? = nil
	
	func loadChallenge() {
		let now = Date()
		let currentMonthIndex = Calendar.current.component(.month, from: now)
		self.challenge = MONTHS[currentMonthIndex - 1]
	}
	
    var body: some View {
        ZStack {
			if ((challenge) != nil) {
				Feed(challenge: challenge)
			}
		}.onAppear(perform: {loadChallenge()})
    }
}

struct ChallengesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesScreen()
    }
}
