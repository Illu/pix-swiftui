//
//  LoginScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import Firebase
import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject var session: SessionStore
    
    @State var email = ""
    @State var password = ""
    @State var loading = false
    @State var error = false
    
    func signIn() {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                self.error = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack {
            Image("chick")
            Text("Welcome back !")
                .font(.largeTitle)
                .foregroundColor(ColorManager.primaryText)
                .multilineTextAlignment(.center)
            
            HStack {
                TextField("Email", text: $email)
                    .padding(10)
            }
            .background(ColorManager.inputBackground)
            .cornerRadius(4.0)
            .frame(maxWidth: BUTTON_WIDTH)
            HStack {
                SecureField("Password", text: $password)
                    .padding(10)
            }
            .background(ColorManager.inputBackground)
            .cornerRadius(4.0)
            .frame(maxWidth: BUTTON_WIDTH)
            Button(action: signIn) {
                LargeButton(title: "Log in")
            }
            .padding(.top, 40)
        }
        .padding()
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginScreen()
        }
    }
}
