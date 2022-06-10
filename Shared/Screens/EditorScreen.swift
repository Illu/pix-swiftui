//
//  EditorScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-30.
//

import SwiftUI

struct EditorScreen: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var app: AppStore
    
    var body: some View {
        VStack {
            if (session.session != nil) {
				PixelEditor().id(app.currentEditorId)
            } else {
                VStack {
                    Text("You must log in to create an artwork.")
						.font(.title)
                    Text("Don't worry, it only takes a few seconds")
                        .foregroundColor(ColorManager.secondaryText)
						.font(.subheadline)
					Button(action: {app.showLoginSheet()}) {
						LargeButton(title: "Log in", withBackground: true).padding(.top, 10)
					}
				}
            }
        }
        .navigationTitle("Create")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditorScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditorScreen()
    }
}
