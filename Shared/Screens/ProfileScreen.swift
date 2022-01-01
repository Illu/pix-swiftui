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
            Text("🚧 Profile Screen")
            if session.session == nil {
                Text("User is not logged in")
                LoginScreen()
            } else {
                HStack {
                Text("User is logged in! id: \(session.session?.uid ?? "error")")
                    Button("Logout") {
                        session.signOut()
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
