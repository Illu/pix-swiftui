//
//  ContentView.swift
//  Shared
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @State private var showLoginSheet = false
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var images: ImagesStore
    @EnvironmentObject var app: AppStore

    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    func loadRemoteContent () {
        // init user listener for the session
        session.listen()
        // load remote images from firebase storage
        images.loadAvatarsURLs()
    }
    
    var body: some View {
        HStack {
            #if os(iOS)
            if horizontalSizeClass == .compact {
                TabBar()
            } else {
                Sidebar()
            }
            #else // MacOS
                Sidebar()
            #endif
        }
        .onAppear(perform: loadRemoteContent)
        .fullScreenCover(
            isPresented: $app.loginSheetVisible,
            onDismiss: { app.hideLoginSheet() }
        ) {
            NavigationView {
                LoginMenuScreen()
                    .toolbar {
                        HStack {
                            Button(action: {app.hideLoginSheet()}) { Text("Cancel") }
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
