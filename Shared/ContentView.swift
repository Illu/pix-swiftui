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
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    func getUser () {
        print("Initializing user")
        session.listen()
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
        .onAppear(perform: getUser)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
