//
//  EditProfile.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-01.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import AlertToast

struct EditProfile: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var images: ImagesStore
    @EnvironmentObject var app: AppStore
    
    @State var avatar = ""
    @State var userName = ""
    @State var email = ""
    @State var password = "sneaky:)"
	@State var willDeleteAccount = false
    @State var state: States = States.IDLE
    @State private var showAvatarSheet = false
    @State private var showAccountDeletionAlert = false
	@State private var showResetEmailAlert = false
	
    private var db = Firestore.firestore()
    
	func saveModifications (logout: Bool = false) {
        self.state = States.LOADING
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = userName
        changeRequest?.commitChanges { error in
            if error != nil {
                self.state = States.ERROR
                app.showToast(toast: AlertToast(type: .error(ColorManager.error), subTitle: error?.localizedDescription))
            } else {
                let updateReference = db.collection("Users").document(session.session!.uid)
                updateReference.getDocument{ (document, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        self.state = States.ERROR
                        app.showToast(toast: AlertToast(type: .error(ColorManager.error), subTitle: err.localizedDescription))
                    } else {
                        document?.reference.updateData([
                            "displayName": userName,
                            "avatar": avatar,
							"disabled": willDeleteAccount
                        ])
						if (logout) {
							if (session.signOut()) {
								app.showToast(toast: AlertToast(type: .regular, title: "Done 💥", subTitle: "Account removed"))
							}
						} else {
							session.loadUserData()
							self.state = States.SUCCESS
							app.showToast(toast: AlertToast(type: .complete(ColorManager.success), title: "Saved"))
						}
                    }
                }
            }
        }
    }
	
	func deleteAccount () {
		print("GO")
		self.willDeleteAccount = true
		self.userName = "[Deleted Account]"
		saveModifications(logout: true)
	}
	
	func resetPassword () {
		session.sendResetPasswordEmail()
		self.showResetEmailAlert = true
	}
    
    func onSelectAvatar (name: String) {
        self.avatar = name
        self.showAvatarSheet = false
    }
	
	func openEmailApp () {
		let emailURL = NSURL(string: "message://")!
			if UIApplication.shared.canOpenURL(emailURL as URL) {
				UIApplication.shared.open(emailURL as URL, options: [:],completionHandler: nil)
			}
	}
	
    var body: some View {
        ScrollView {
        VStack {
            RoundedAvatar(name: avatar, size: 140)
            Button(action: { showAvatarSheet.toggle()}) {
                LargeButton(title: "Edit profile picture", width: 200)
            }
			VStack(alignment: .leading) {
				Text("Username").fontWeight(.semibold).padding([.top], 8)
				HStack {
					TextField("Username", text: $userName)
						.padding(10)
				}
				.background(ColorManager.inputBackground)
				.cornerRadius(4.0)
				.frame(maxWidth: BUTTON_WIDTH)
			}
			VStack(alignment: .leading) {
				Text("Your email").fontWeight(.semibold).padding([.top], 8)
				HStack {
					TextField("Email", text: $email)
						.padding(10)
						.foregroundColor(ColorManager.secondaryText)
						.disabled(true)
				}
				.background(ColorManager.inputBackground)
				.cornerRadius(4.0)
				.frame(maxWidth: BUTTON_WIDTH)
			}
			VStack(alignment: .leading) {
				Text("Your password").fontWeight(.semibold).padding([.top], 8)
				HStack {
					SecureField("Password", text: $password)
						.padding(10)
						.foregroundColor(ColorManager.secondaryText)
						.disabled(true)
				}
				.background(ColorManager.inputBackground)
				.cornerRadius(4.0)
				.frame(maxWidth: BUTTON_WIDTH)
			}
			VStack {
				Button(action: resetPassword) {
					Text("Reset my password")
				}
				Button(action: { saveModifications(logout: false) } ) {
					LargeButton(title: "Save modifications", loading: self.state == States.LOADING, withBackground: true)
				}
				.padding(.vertical, 40)
			}
            Text("ID - \(session.session?.uid ?? "??")")
                .foregroundColor(ColorManager.secondaryText)
                .opacity(0.2)
				.contextMenu {
					Button(action: {UIPasteboard.general.string = session.session?.uid ?? ""}) { HStack {Text("Copy ID"); Spacer(); Image(systemName: "doc.on.doc")}}
				}
        }
        .onAppear(perform: {
            self.userName = session.userData?.displayName ?? ""
            self.email = session.session?.email ?? ""
            self.avatar = session.userData?.avatar ?? images.avatars[0].name
        })
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
		.toolbar {
			HStack {
				Menu {
					Button(action: { self.showAccountDeletionAlert = true }) { HStack {Text("Delete your account"); Spacer(); Image(systemName: "trash") }}
				} label: {
					Image(systemName: "ellipsis")
				}
			}
			.alert(isPresented: $showResetEmailAlert) {
					Alert(
						title: Text("📬 Check your email"),
						message: Text("An email with further instructions should arrive soon!"),
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
		}
		.alert(isPresented: $showAccountDeletionAlert) {
				Alert(
					title: Text("⚠️ Warning ⚠️"),
					message: Text("Are you sure you want to delete your account data?\n\nThis action CANNOT be undone."),
					primaryButton: .default(
						Text("No, take me back"),
						action: {}
					),
					secondaryButton: .destructive(
						Text("Yes, I know what I'm doing"),
						action: { deleteAccount() }
					)
				)
			}
        .sheet(
            isPresented: $showAvatarSheet,
            onDismiss: { self.showAvatarSheet = false }
        ) {
            NavigationView {
                AvatarList(onSelectAvatar: onSelectAvatar)
                    .navigationTitle("Avatars")
                    .toolbar {
                        Button(action: {self.showAvatarSheet = false}) { Text("Cancel") }
                    }
            }
        }
        }
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}
