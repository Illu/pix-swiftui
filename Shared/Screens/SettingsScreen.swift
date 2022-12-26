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
							HStack {SettingsIcon(iconName: "rectangle.portrait.and.arrow.right", color: Color(hex: "#ED6A5A")); Text("Log me out"); Spacer() }.foregroundColor(ColorManager.primaryText)
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
							SettingsIcon(iconName: "person.circle", color: Color(hex: "#4DB3FF"))
                            Text("Account")
                        }
                    } else {
						Button(action: {
							app.showLoginSheet()
						}) { HStack {SettingsIcon(iconName: "arrow.right.circle", color: Color(hex: "#35CE8D")); Text("Log in"); Spacer() }.foregroundColor(ColorManager.primaryText)}
                    }
                }
				Section("Preferences") {
					NavigationLink(destination: EditorSettingsScreen()) {
						SettingsIcon(iconName: "paintpalette", color: Color(hex: "#4DB3FF"))
						Text("Editor")
					}
				}
                Section("Contact") {
                    Link(destination: URL(string: "https://www.twitter.com/maximenory")!) {
						HStack {
							SettingsIcon(iconName: "message", color: Color(hex: "#ED6A5A"))
							Text("Say hi").foregroundColor(ColorManager.primaryText)
						}
                    }
                    NavigationLink(destination: TipScreen()) {
						SettingsIcon(iconName: "dollarsign.circle", color: Color(hex: "#FFB800"))
                        Text("Leave a tip")
                    }
                }
                Section("App") {
                    NavigationLink(destination: AboutScreen()) {
						SettingsIcon(iconName: "info.circle", color: Color(hex: "#35CE8D"))
                        Text("About Pix")
                    }
					Button(action: {
						SKStoreReviewController.requestReview()
					}) {
						HStack {
							SettingsIcon(iconName: "star", color: Color(hex: "#4DB3FF"))
							Text("Rate the App").foregroundColor(ColorManager.primaryText)
						}
					}
					NavigationLink(destination: NewsScreen()) {
						SettingsIcon(iconName: "sparkles", color: Color(hex: "#FFB800"))
						Text("What's new")
					}
					Link(destination: URL(string: "https://www.github.com/illu/pix")!) {
						HStack {
							SettingsIcon(iconName: "chevron.left.forwardslash.chevron.right", color: Color(hex: "#4DB3FF"))
							Text("Source Code").foregroundColor(ColorManager.primaryText)
						}
					}
                }
				VStack {
					Text(verbatim: "\(Calendar(identifier: .gregorian).dateComponents([.year], from: .now).year ?? 2023) - Maxime Nory")
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
