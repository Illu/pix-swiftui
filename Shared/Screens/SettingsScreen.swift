//
//  SettingsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        NavigationView {
            VStack{
                Text("test")
            }
        }.navigationBarTitle(Text("Settings"))
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
