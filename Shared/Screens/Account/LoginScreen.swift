//
//  LoginScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import Firebase
import SwiftUI
import AlertToast

struct LoginScreen: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var app: AppStore
	@State private var showResetEmailAlert = false

    @State var email = ""
    @State var password = ""
    @State var loading = false
    @State var error = false
    
	func resetPassword () {
		session.sendResetPasswordEmailTo(email: email)
		self.showResetEmailAlert = true
	}
	
	func openEmailApp () {
		let emailURL = NSURL(string: "message://")!
			if UIApplication.shared.canOpenURL(emailURL as URL) {
				UIApplication.shared.open(emailURL as URL, options: [:],completionHandler: nil)
			}
	}
	
    func signIn() {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                self.error = true
                self.loading = false
                app.showToast(toast: AlertToast(type: .error(ColorManager.error), subTitle: error?.localizedDescription ?? "Unable to login"))
            } else {
                self.email = ""
                self.password = ""
                self.loading = false
                app.hideLoginSheet()
                app.showToast(toast: AlertToast(type: .complete(ColorManager.success), title: "Logged in !"))
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
					.keyboardType(.emailAddress)
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
			Button(action: resetPassword) {
				Text("Reset my password")
			}
			.disabled(email == "")
			.alert(isPresented: $showResetEmailAlert) {
					Alert(
						title: Text("📬 Check your email"),
						message: Text("An email with further instructions has been sent to \(email) and should arrive soon!"),
						primaryButton: .default(
							Text("Open my email App"),
							action: openEmailApp
						),
						secondaryButton: .default(
							Text("Close"),
							action: {}
						)
					)
				}
            Button(action: signIn) {
                LargeButton(title: "Log in", loading: loading, disabled: (loading || (email == "" && password == "")))
			}.disabled((loading || (email == "" && password == "")))
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
