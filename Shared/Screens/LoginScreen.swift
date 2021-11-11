//
//  LoginScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import Firebase
import SwiftUI

struct LoginScreen: View {
    @State var email = ""
    @State var password = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button(action: { login() }) {
                Text("Sign in")
            }
        }
        .padding()
    }

    func login() {
        print("login!")
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginScreen()
        }
    }
}
