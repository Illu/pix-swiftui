//
//  SettingsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI
import AlertToast

struct SettingsScreen: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var app: AppStore

    var body: some View {
        VStack{
            List {
                Section("Account") {
                    if (session.session != nil) {
						Button(action: {
							if (session.signOut()) {
								app.showToast(toast: AlertToast(type: .regular, title: "See you later 👋", subTitle: "Logged out successfully."))
							}
						}) { HStack {Image(systemName: "rectangle.portrait.and.arrow.right"); Text("Log out"); Spacer() }.foregroundColor(ColorManager.primaryText)}
                        NavigationLink(destination: EditProfile()) {
                            Image(systemName: "person.circle")
                            Text("Edit Profile")
                        }
                    } else {
                        Button("Log in") {
                            app.showLoginSheet()
                        }
                    }
                }
                Section("Contact") {
                    NavigationLink(destination: EditProfile()) {
                        Image(systemName: "message")
                        Text("Say hi")
                    }
                    NavigationLink(destination: EditProfile()) {
                        Image(systemName: "dollarsign.circle")
                        Text("Leave a tip")
                    }
                }
                Section("App") {
                    NavigationLink(destination: AboutScreen()) {
                        Image(systemName: "info.circle")
                        Text("About Pix")
                    }
                    NavigationLink(destination: EditProfile()) {
                        Image(systemName: "star")
                        Text("Rate the App")
                    }
                }
            }
			.listStyle(.insetGrouped)
			.overlay(
				VStack {
					Spacer()
					Text("2022 - Maxime Nory")
						.font(.footnote)
						.foregroundColor(ColorManager.secondaryText)
						.frame(maxWidth: .infinity)
				}
			)
        }.navigationBarTitle(Text("Settings"))
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
