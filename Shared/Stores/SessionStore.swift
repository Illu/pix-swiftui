//
//  SessionStore.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-29.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Combine
import FirebaseFirestore

class SessionStore: ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    
    @Published var session: SessionUser? { didSet { self.didChange.send(self) }}
    @Published var userData: UserData?
	@Published var isAdmin: Bool = false
    
    var handle: AuthStateDidChangeListenerHandle?
    
    private var db = Firestore.firestore()
    
    func listen () {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                self.session = SessionUser(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                )
                self.loadUserData()
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
                self.userData = nil
            }
        }
    }
    
    func loadUserData () {
        let docRef = self.db.collection("Users").document(self.session!.uid)
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print ("error: \(error.localizedDescription)")
            }
            else {
                if let document = document {
                    do {
                        self.userData = try document.data(as: UserData.self)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            print("error signing out :(")
            return false
        }
    }
    
    func unbind () {
            if let handle = handle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
	
	func sendResetPasswordEmail () {
		Auth.auth().sendPasswordReset(withEmail: (self.session?.email)!)
	}
	
	func enableAdmin () {
		self.isAdmin = true
	}
}
