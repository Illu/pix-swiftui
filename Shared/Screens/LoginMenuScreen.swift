//
//  LoginMenuScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-31.
//

import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices
import AlertToast
import FirebaseFirestore

struct LoginMenuScreen: View {
    @State var currentNonce:String?
    
    @EnvironmentObject var app: AppStore
    
    //Hashing function using CryptoKit
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func onLogin () {
        app.hideLoginSheet()
        app.showToast(toast: AlertToast(type: .complete(ColorManager.success), title: "Logged in!"))
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
            NavigationLink(destination: AccountCreation()) {
                LargeButton(title: "Create an account")
            }
            NavigationLink(destination: LoginScreen()) {
                LargeButton(title: "Log in")
            }
            SignInWithAppleButton(
                onRequest: { request in
                    let nonce = randomNonceString()
                    currentNonce = nonce
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = sha256(nonce)
                },
                onCompletion: { result in
                    let db = Firestore.firestore()
                    switch result {
                    case .success(let authResults):
                        switch authResults.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            
                            guard let nonce = currentNonce else {
                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                            }
                            guard let appleIDToken = appleIDCredential.identityToken else {
                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                            }
                            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                return
                            }
                            
                            let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                            Auth.auth().signIn(with: credential) { (authResult, error) in
                                if (error != nil) {
                                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                                    // you're sending the SHA256-hashed nonce as a hex string with
                                    // your request to Apple.
                                    print(error?.localizedDescription as Any)
                                    return
                                }
                                print("signed in")
                                // Check if the user already exists
                                let docRef = db.collection("Users").document(authResult!.user.uid)
                                docRef.getDocument { (document, error) in
                                    if (document?.exists == true) {
                                        // Document already exist, simply log the user in
                                        print("user already exist, loggin in..")
                                        onLogin()
                                    } else {
                                        // Document does not exist, create account data
                                        docRef.setData([
                                            "displayName": "Unknown Artist",
                                            "badges": [],
                                            "avatar": "cat-1"
                                        ]) { err in
                                            if let err = err {
                                                print("Error creating user document: \(err)")
                                            } else {
                                                onLogin()
                                            }
                                        }
                                    }
                                }
                            }
                        default:
                            break
                            
                        }
                    default:
                        break
                    }
                }
            ).frame(width: BUTTON_WIDTH, height: 45, alignment: .center)
            
        }
        .padding(30)
    }
}

struct LoginMenu_Previews: PreviewProvider {
    static var previews: some View {
        LoginMenuScreen()
    }
}
