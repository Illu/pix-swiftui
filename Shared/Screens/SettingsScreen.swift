//
//  SettingsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI
import AlertToast

struct SettingsIcon: View {
	var iconName: String
	var color: Color?
	
	var body: some View {
		HStack {
			Image(systemName: iconName).foregroundColor(.white)
		}.frame(width: 36, height: 36).background(color).cornerRadius(5).padding(.trailing, 6)
	}
}

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
						}) { HStack {SettingsIcon(iconName: "rectangle.portrait.and.arrow.right", color: .red); Text("Log out"); Spacer() }.foregroundColor(ColorManager.primaryText)}
                        NavigationLink(destination: EditProfile()) {
							SettingsIcon(iconName: "person.circle", color: .blue)
                            Text("Account")
                        }
                    } else {
                        Button("Log in") {
                            app.showLoginSheet()
                        }
                    }
                }
                Section("Contact") {
                    NavigationLink(destination: EditProfile()) {
						SettingsIcon(iconName: "message", color: .green)
                        Text("Say hi")
                    }
                    NavigationLink(destination: EditProfile()) {
						SettingsIcon(iconName: "dollarsign.circle", color: .yellow)
                        Text("Leave a tip")
                    }
                }
                Section("App") {
                    NavigationLink(destination: AboutScreen()) {
						SettingsIcon(iconName: "info.circle", color: .orange)
                        Text("About Pix")
                    }
					NavigationLink(destination: EditProfile()) {
						SettingsIcon(iconName: "star", color: .blue)
						Text("Rate the App")
					}
					NavigationLink(destination: RequestNewFeatureScreen()) {
						SettingsIcon(iconName: "sparkles", color: .yellow)
						Text("Suggest new features")
					}
					NavigationLink(destination: EditProfile()) {
						SettingsIcon(iconName: "chevron.left.forwardslash.chevron.right", color: .purple)
						Text("Source Code")
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
