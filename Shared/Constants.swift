//
//  Constants.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import Foundation
import SwiftUI

enum Sorting : String {
    case top = "likesCount"
    case new = "timestamp"
}

struct Tab: Identifiable {
    var id = UUID()
    var name: String
    var systemImage: String
    var view: AnyView
}

let Tabs = [
    Tab(name: "Home", systemImage: "house", view: AnyView(HomeScreen())),
    Tab(name: "Challenges", systemImage: "crown", view: AnyView(HomeScreen())),
    Tab(name: "Create", systemImage: "plus.square", view: AnyView(HomeScreen())),
    Tab(name: "Profile", systemImage: "person", view: AnyView(LoginScreen())),
    Tab(name: "Settings", systemImage: "gearshape", view: AnyView(SettingsScreen()))
]

let PAGE_ITEMS = 5 // how many items are fetched in the feed
