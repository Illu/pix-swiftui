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
						.multilineTextAlignment(.center)
                    Text("If you aren't registered yet, creating an account only takes a few seconds")
						.multilineTextAlignment(.center)
                        .foregroundColor(ColorManager.secondaryText)
						.font(.subheadline)
						.padding([.vertical], 16)
					Button(action: {app.showLoginSheet()}) {
						LargeButton(title: "Sign in", withBackground: true).padding(.top, 10)
					}
				}
				.padding(16)
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
