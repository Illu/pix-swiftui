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
                PixelEditor()
            } else {
                VStack {
                    Text("You must log in to create an artwork")
                    Text("Don't worry, it only takes a few seconds")
                        .foregroundColor(ColorManager.secondaryText)
                    Button("Log in") {
                        app.showLoginSheet()
                    }
                }
            }
            
           
        }
        .navigationTitle("Create")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: {print("next")}) {
                Image(systemName: "arrow.right")
            }
        }
    }
}

struct EditorScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditorScreen()
    }
}
