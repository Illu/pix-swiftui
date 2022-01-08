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
    @State var state: States = States.IDLE
    @State private var showAvatarSheet = false
    
    private var db = Firestore.firestore()
    
    func saveModifications () {
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
                            "avatar": avatar
                        ])
                        session.loadUserData()
                        self.state = States.SUCCESS
                        app.showToast(toast: AlertToast(type: .complete(ColorManager.success), title: "Saved"))
                    }
                }
            }
        }
    }
    
    func onSelectAvatar (name: String) {
        self.avatar = name
        self.showAvatarSheet = false
    }
    
    func formLabel (text: String) -> Text { return Text(text) }
    
    var body: some View {
        VStack {
            RoundedAvatar(name: avatar, size: 100)
            Button(action: { showAvatarSheet.toggle()}) {
                LargeButton(title: "Edit profile picture", width: 200)
            }
            formLabel(text: "Username")
            HStack {
                TextField("Username", text: $userName)
                    .padding(10)
            }
            .background(ColorManager.inputBackground)
            .cornerRadius(4.0)
            .frame(maxWidth: BUTTON_WIDTH)
            formLabel(text: "Your email")
            HStack {
                TextField("Email", text: $email)
                    .padding(10)
                    .foregroundColor(ColorManager.secondaryText)
                    .disabled(true)
            }
            .background(ColorManager.inputBackground)
            .cornerRadius(4.0)
            .frame(maxWidth: BUTTON_WIDTH)
            formLabel(text: "Your password")
            HStack {
                SecureField("Password", text: $password)
                    .padding(10)
                    .foregroundColor(ColorManager.secondaryText)
                    .disabled(true)
            }
            .background(ColorManager.inputBackground)
            .cornerRadius(4.0)
            .frame(maxWidth: BUTTON_WIDTH)
            Button(action: saveModifications) {
                LargeButton(title: "Save modifications", loading: self.state == States.LOADING, withBackground: true)
            }
            .padding(.top, 40)
            Text("ID - \(session.session?.uid ?? "??")")
                .foregroundColor(ColorManager.secondaryText)
                .opacity(0.5)
        }
        .onAppear(perform: {
            self.userName = session.userData?.displayName ?? ""
            self.email = session.session?.email ?? ""
            self.avatar = session.userData?.avatar ?? images.avatars[0].name
        })
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(
            isPresented: $showAvatarSheet,
            onDismiss: { self.showAvatarSheet = false }
        ) {
            NavigationView {
                AvatarList(onSelectAvatar: onSelectAvatar)
                    .navigationTitle("Choose an avatar")
                    .toolbar {
                        Button(action: {self.showAvatarSheet = false}) { Text("Cancel") }
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
