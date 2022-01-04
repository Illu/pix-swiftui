//
//  ChallengesScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-30.
//

import SwiftUI

struct ChallengesScreen: View {
    
    var body: some View {
        ZStack {
            VStack {
                CurrentChallengeCard()
                Empty()
            }
        }
        .navigationTitle("Challenges")
    }
}

struct ChallengesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesScreen()
    }
}
