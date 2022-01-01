//
//  ContentView.swift
//  Shared
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var images: ImagesStore

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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
