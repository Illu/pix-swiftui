//
//  Sidebar.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-16.
//

import SwiftUI

struct Sidebar: View {
    
    @State var selection: Int? = -1
    
    var body: some View {
        NavigationView {
			VStack {
            List {
                ForEach(Tabs.indices) { i in
					NavigationLink(destination: Tabs[i].view, tag: i, selection: $selection) {
                        Label(Tabs[i].name, systemImage: Tabs[i].systemImage)
                            .environment(\.symbolVariants, .none)
                    }
                }
				}.listStyle(.sidebar)
            }
			.background(ColorManager.screenBackground)
            .onAppear {
                if self.selection == -1 {
                    self.selection = 0
                }
            }
            .navigationTitle("Pix")
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
