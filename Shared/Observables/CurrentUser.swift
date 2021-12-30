//
//  CurrentUser.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-29.
//

import Foundation
import FirebaseAuth

class CurrentUser: ObservableObject {
    @Published var user: FirebaseAuth.User? = nil
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Login Error")
            } else {
                print("success")
                self.user = result?.user
            }
        }
    }
}
