//
//  SettingsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI

struct SettingsScreen: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var app: AppStore

    var body: some View {
        VStack{
            List {
                Section("Account") {
                    if (session.session != nil) {
                        Button("Log out") {
                            session.signOut()
                        }
                    } else {
                        Button("Log in") {
                            app.showLoginSheet()
                        }
                    }
                }
                Section("App") {
                    Button("About") {
                        
                    }
                }
            }.listStyle(.insetGrouped)
        }.navigationBarTitle(Text("Settings"))
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
