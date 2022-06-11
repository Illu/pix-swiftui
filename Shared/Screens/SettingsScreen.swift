//
//  SettingsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI
import AlertToast
import StoreKit

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
	@State private var showingLogoutAlert = false
	
    var body: some View {
        VStack{
            List {
                Section("Account") {
                    if (session.session != nil) {
						Button(action: { showingLogoutAlert = true }) {
							HStack {SettingsIcon(iconName: "rectangle.portrait.and.arrow.right", color: .red); Text("Log me out"); Spacer() }.foregroundColor(ColorManager.primaryText)
						}.alert("Do you really want to log out?", isPresented: $showingLogoutAlert) {
							Button("Yes please") {
								if (session.signOut()) {
									app.showToast(toast: AlertToast(type: .regular, title: "See you later 👋", subTitle: "Logged out successfully."))
								}
							}
							Button("Nope") {
								showingLogoutAlert = false
							}
						}
                        NavigationLink(destination: EditProfile()) {
							SettingsIcon(iconName: "person.circle", color: .blue)
                            Text("Account")
                        }
                    } else {
						Button(action: {
							app.showLoginSheet()
						}) { HStack {SettingsIcon(iconName: "arrow.right.circle", color: .blue); Text("Log in"); Spacer() }.foregroundColor(ColorManager.primaryText)}
                    }
                }
                Section("Contact") {
                    Link(destination: URL(string: "https://www.twitter.com/maximenory")!) {
						HStack {
							SettingsIcon(iconName: "message", color: .green)
							Text("Say hi").foregroundColor(ColorManager.primaryText)
						}
                    }
                    NavigationLink(destination: TipScreen()) {
						SettingsIcon(iconName: "dollarsign.circle", color: .yellow)
                        Text("Leave a tip")
                    }
                }
                Section("App") {
                    NavigationLink(destination: AboutScreen()) {
						SettingsIcon(iconName: "info.circle", color: .orange)
                        Text("About Pix")
                    }
					Button(action: {
						SKStoreReviewController.requestReview()
					}) {
						HStack {
							SettingsIcon(iconName: "star", color: .blue)
							Text("Rate the App").foregroundColor(ColorManager.primaryText)
						}
					}
					NavigationLink(destination: NewsScreen()) {
						SettingsIcon(iconName: "sparkles", color: .yellow)
						Text("What's new")
					}
					Link(destination: URL(string: "https://www.github.com/illu/pix")!) {
						HStack {
							SettingsIcon(iconName: "chevron.left.forwardslash.chevron.right", color: .purple)
							Text("Source Code").foregroundColor(ColorManager.primaryText)
						}
					}
                }
				VStack {
					Text("2022 - Maxime Nory")
						.font(.footnote)
						.foregroundColor(ColorManager.secondaryText)
						.frame(maxWidth: .infinity)
						.listRowInsets(EdgeInsets())
				}.listRowBackground(Color.clear)
            }
			.listStyle(.insetGrouped)
        }
		.navigationBarTitle(Text("Settings"))
		.navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
