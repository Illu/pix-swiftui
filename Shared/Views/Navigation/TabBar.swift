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
                NavigationView {
                    tab.view
                }
                .background(ColorManager.screenBackground)
                .tabItem{
					Image(systemName: tab.systemImage)
                    Label(tab.name, systemImage: tab.systemImage)
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
