//
//  ProfileScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-29.
//

import SwiftUI

struct ProfileScreen: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var images: ImagesStore
    
    var body: some View {
        VStack {
            if session.session == nil {
                LoginMenuScreen()
            } else {
                VStack {
                    HStack {
                        RoundedAvatar(name: session.userData?.avatar, size: 100)
                        VStack {
                            Text(session.userData?.displayName ?? "Name Error")
                            Text("TODO: X Post(s)")
                        }
                    }
                    NavigationLink("Edit Profile") {
                        EditProfile()
                    }
                }
            }
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
