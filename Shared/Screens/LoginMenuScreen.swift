//
//  LoginMenuScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-31.
//

import SwiftUI

struct LoginMenuScreen: View {
    
    func onCreateAccount() {
        
    }
    
    func onLogin() {
        
    }
    
    var body: some View {
        VStack {
            Image("koala")
            Text("Hi there !")
                .font(.largeTitle)
                .foregroundColor(ColorManager.primaryText)
                .multilineTextAlignment(.center)
            Text("Log in or create an account to share your work and fully enjoy the app and its community !")
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.vertical, 16)
            NavigationLink(destination: Text("Replace me with the create account screen!")) {
                LargeButton(title: "Create an account")
            }
            NavigationLink(destination: LoginScreen()) {
                LargeButton(title: "Log in")
            }
            
        }
        .padding(30)
    }
}

struct LoginMenu_Previews: PreviewProvider {
    static var previews: some View {
        LoginMenuScreen()
    }
}
