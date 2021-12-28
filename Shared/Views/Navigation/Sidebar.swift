//
//  Sidebar.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-16.
//

import SwiftUI

struct Sidebar: View {
    
    @State var selection: Int?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Tabs.indices) { i in
                    NavigationLink(destination: Tabs[i].view, tag: i, selection: self.$selection) {
                        Label(Tabs[i].name, systemImage: Tabs[i].systemImage)
                            .environment(\.symbolVariants, .none)
                    }
                }
            }
            .onAppear {
                if self.selection == nil {
                    self.selection = 0
                }
            }
            .navigationTitle("Logo")
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
