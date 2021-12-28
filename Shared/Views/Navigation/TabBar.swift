//
//  TabBar.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-16.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView() {
            ForEach(Tabs) { tab in
                tab.view.tabItem{
                    Label(tab.name, systemImage: tab.systemImage)
                        .environment(\.symbolVariants, .none)
                }
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
