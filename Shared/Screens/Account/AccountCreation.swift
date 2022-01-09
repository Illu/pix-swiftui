//
//  AccountCreation.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-05.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import AlertToast

struct AccountCreation: View {
    @State var username = ""
    @State var email = ""
    @State var error = ""
    @State var password = ""
    @State var passwordConfirmation = ""
    @State var loading = false
    @State var step = 0
    
    @EnvironmentObject var app: AppStore
    
    func onPressActionButton () {
        
        let db = Firestore.firestore()
        let auth = Auth.auth()
        
        if (step == 0) {
            self.step = 1
        } else {
            // create account here
            if (password != passwordConfirmation) {
                self.error = "Passwords do not match!"
                return
            } else {
                self.loading = true
                print("email: \(email)")
                print("pass: \(password)")
                
                auth.createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print(error)
                        self.error = "There was an error while creating your account: \(error)"
                        self.loading = false
                    } else {
                        print("User account created & signed in!, setting username...")
                        db.collection("Users").document(authResult!.user.uid).setData([
                            "displayName": username,
                            "badges": [],
                            "avatar": "cat-1"
                        ]) { err in
                            if let err = err {
                                print("Error creating user document: \(err)")
                                self.loading = false
                                self.error = "Your account has been created, but somehow an error occured, some things might not work as expected"
                            } else {
                                app.hideLoginSheet()
                                app.showToast(toast: AlertToast(type: .complete(ColorManager.success), title: "Welcome to Pix!", subTitle: "Your account has been created."))
                                self.loading = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Image("birb")
                Text("Welcome to Pix!")
                    .font(.title)
                    .padding(.top, 30)
                Text("Create your account and enjoy the app and its community!")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: BUTTON_WIDTH)
                    .foregroundColor(ColorManager.secondaryText)
            }
            Text(error)
                .padding(.top, 16)
                .padding(.bottom, 10)
                .foregroundColor(ColorManager.error)
                .frame(maxWidth: BUTTON_WIDTH, alignment: .leading)
            if (step == 0) {
                VStack {
                    Text("First, choose your username")
                        .fontWeight(.medium)
                        .frame(maxWidth: BUTTON_WIDTH, alignment: .leading)
                    HStack {
                        TextField("Your username", text: $username)
                            .padding(10)
                    }
                    .background(ColorManager.inputBackground)
                    .cornerRadius(4.0)
                    .frame(maxWidth: BUTTON_WIDTH)
                    Text("Your email")
                        .fontWeight(.medium)
                        .frame(maxWidth: BUTTON_WIDTH, alignment: .leading)
                    HStack {
                        TextField("Your email", text: $email)
                            .padding(10)
                    }
                    .background(ColorManager.inputBackground)
                    .cornerRadius(4.0)
                    .frame(maxWidth: BUTTON_WIDTH)
                    .padding(.bottom, 40)
                }
            } else if (step == 1) {
                VStack {
                    Text("Your password")
                        .fontWeight(.medium)
                        .frame(maxWidth: BUTTON_WIDTH, alignment: .leading)
                    HStack {
                        SecureField("", text: $password)
                            .padding(10)
                    }
                    .background(ColorManager.inputBackground)
                    .cornerRadius(4.0)
                    .frame(maxWidth: BUTTON_WIDTH)
                    Text("Confirm your password")
                        .fontWeight(.medium)
                        .frame(maxWidth: BUTTON_WIDTH, alignment: .leading)
                    HStack {
                        SecureField("", text: $passwordConfirmation)
                            .padding(10)
                    }
                    .background(ColorManager.inputBackground)
                    .cornerRadius(4.0)
                    .frame(maxWidth: BUTTON_WIDTH)
                    .padding(.bottom, 40)
                }
            }
            VStack {
                Button(action: {onPressActionButton()}) {
                    LargeButton(
                        title: self.step == 1 ? "Create my account" : "Next",
                        loading: loading, withBackground: true,
                        disabled: self.step == 1 ? (password.isEmpty && passwordConfirmation.isEmpty) : (email.isEmpty && username.isEmpty)
                    )
                }.disabled(self.step == 1 ? (password.isEmpty && passwordConfirmation.isEmpty) : (email.isEmpty && username.isEmpty))
                Button(action: {self.step = 0}) {
                    LargeButton(title: "Back")
                }
                .opacity(self.step == 0 ? 0 : 1)
                HStack {
                    Text("Already have an account ?")
                    Button("Log in !") {}
                }
                .font(.footnote)
                .padding(.top, 10)
            }
            Spacer()
        }.padding(30)
    }
}

struct AccountCreation_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreation()
    }
}
