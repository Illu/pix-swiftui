//
//  AboutScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-09.
//

import SwiftUI

struct AboutScreen: View {
	var body: some View {
		VStack {
			List {
				HStack {
					Spacer()
					RoundedRectangle(cornerRadius: 20)
						.fill(ColorManager.primaryText)
						.frame(width: 100, height: 100)
					VStack(alignment: .leading) {
						Text("Pix \(Bundle.main.releaseVersionNumber ?? "(Unknown version 🥸)")").fontWeight(.semibold)
						Text("by Maxime Nory").foregroundColor(ColorManager.secondaryText)
					}
					Spacer()
				}.listRowBackground(Color.clear)
				Section ("What is Pix ?") {
					Text("Pix is an online pixel art community. Share your creations with everyone to contribute to the App! If you have any questions or suggestion, feel free to contact me, I'll be glad to hear from you!")
				}
				Section ("Privacy policy") {
					Link(destination: URL(string: "https://maximenory.com/pix")!) {
						Text("Tap here to open our privacy policy informations using your default web browser").foregroundColor(ColorManager.primaryText)
					}
				}
			}
		}
	}
}

struct AboutScreen_Previews: PreviewProvider {
	static var previews: some View {
		AboutScreen()
	}
}
