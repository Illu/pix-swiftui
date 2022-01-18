//
//  RequestNewFeatureScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-17.
//

import SwiftUI

struct RequestNewFeatureScreen: View {
    var body: some View {
		VStack {
			Image(systemName: "lightbulb").foregroundColor(ColorManager.secondaryText)
			Text("Do you have an idea for a new feature? Is there something you would like to change in the App? Write anything you want and I'll read it!")
			Text("Note: your feedback won't be visible to other members and will be kept anonymous").foregroundColor(ColorManager.secondaryText)
		}
		.navigationTitle("Suggestion Box")
		.navigationBarTitleDisplayMode(.inline)
    }
}

struct RequestNewFeatureScreen_Previews: PreviewProvider {
    static var previews: some View {
        RequestNewFeatureScreen()
    }
}
