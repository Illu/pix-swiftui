//
//  HomeScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var feed = FeedModel()
    
    private var screenTitle: [Sorting : String] = [.top: "Top", .new: "New"]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    PostCard()
                }
            LoginScreen()
            }
            .navigationBarTitle(Text(screenTitle[feed.sortMethod] ?? "Error"))
            .navigationBarItems(leading:
                HStack {
                Text("Pix")
                    .font(.title)
                        .bold()
                }, trailing:
                HStack {
                Button(action: {
                    feed.changeSorting(newSorting: .new)
                }) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            )
        }
        .environmentObject(feed)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
