//
//  Login.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import Firebase
import SwiftUI

struct Login: View {
    
    @EnvironmentObject var currentUser: CurrentUser
    
    @State var email = ""
    @State var password = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button(action: { currentUser.login(email: email, password: password) }) {
                Text("Sign in")
            }
        }
        .padding()
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Login()
        }
    }
}
