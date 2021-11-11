//
//  ContentView.swift
//  Shared
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        
        TabView() {
            HomeScreen()
                .tabItem{
                    Label("Home", systemImage: "house")
                        .environment(\.symbolVariants, .none)
                }
            HomeScreen()
                .tabItem {
                    Label("Challenges", systemImage: "crown")
                        .environment(\.symbolVariants, .none)
                }
            HomeScreen()
                .tabItem {
                    Label("Create", systemImage: "plus.square")
                        .environment(\.symbolVariants, .none)
                }
            HomeScreen()
                .tabItem {
                    Label("Profile", systemImage: "person")
                        .environment(\.symbolVariants, .none)
                }
            HomeScreen()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                        .environment(\.symbolVariants, .none)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView().preferredColorScheme(.dark)
    }
}
