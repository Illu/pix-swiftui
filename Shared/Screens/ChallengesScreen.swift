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
            ColorManager.screenBackground
            VStack {
                Text("🚧 Challenges")
                Empty()
            }
        }
        .navigationTitle("Challenges")
        .background(ColorManager.screenBackground)
    }
}

struct ChallengesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesScreen()
    }
}
