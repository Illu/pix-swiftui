//
//  ProfileScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-29.
//

import SwiftUI

struct ProfileScreen: View {
    
    @StateObject var currentUser = CurrentUser()
    
    var body: some View {
        VStack {
            Text("🚧 Profile Screen")
            if currentUser.user == nil {
                Text("User is not logged in")
                Login()
            } else {
                Text("User is logged in! id: \(currentUser.user?.uid ?? "error")")
            }
        }
        .environmentObject(currentUser)
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
