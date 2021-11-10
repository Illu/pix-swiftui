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
        NavigationView {
            VStack {
                List {
                    PostCard()
                }
            LoginScreen()
            }
            .navigationBarTitle(Text("Trending"))
            .navigationBarItems(leading:
                HStack {
                    Text("Pix Logo").bold()
                }, trailing:
                HStack {
                    Button("Settings") {
                        print("Settings tapped!")
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
