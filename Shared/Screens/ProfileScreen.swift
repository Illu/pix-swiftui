//
//  ProfileScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-29.
//

import SwiftUI

struct ProfileScreen: View {
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack {
            if (session.session == nil) {
                LoginMenuScreen()
            } else {
                ProfileData(userId: session.session?.uid ?? "", isCurrentSessionProfile: true)
            }
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
