//
//  pixApp.swift
//  Shared
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI
import Firebase

@main
struct pixApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SessionStore())
                .environmentObject(ImagesStore())
                .environmentObject(ChallengeStore())
                .environmentObject(AppStore())
        }
    }
}
