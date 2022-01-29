//
//  SubmitScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-23.
//

import SwiftUI

struct SubmitScreen: View {
	var postData: PostData
	
	@State var description: String = ""
	@State var addChallengeTag = false
	
    var body: some View {
		VStack(alignment: .leading) {
//			ScrollView {
			GeometryReader { geometry in
				PixelArt(data: postData, pixelSize: geometry.size.width / ART_SIZE)
					.frame(width: geometry.size.width, height: geometry.size.width)
			}
			Text("A quick word about your masterpiece ?")
				.fontWeight(.semibold)
			TextField("Description", text: $description)
				.padding(.horizontal, 16)
				.padding(.vertical, 10)
				.submitLabel(.continue)
				.onSubmit {
					// todo
				}
				.overlay(
					RoundedRectangle(cornerRadius: 4.0)
						.stroke(ColorManager.inputBackground, lineWidth: 1)
				)
			HStack {
				VStack {
					Text("I'm participating in this month challenge").fontWeight(.semibold)
					Text("Learn more").fontWeight(.medium).underline()
				}
				.background(.orange)
				.frame(maxWidth: .infinity)
				Toggle("", isOn: $addChallengeTag).labelsHidden()
			}
		}
		.padding(16)
		.toolbar {
			Button(action: {}) {
				HStack {
					Text("Publish").foregroundColor(.white).padding(.horizontal, 20).padding(.vertical, 5)
				}.background(RoundedRectangle(cornerRadius: 6)).padding(4)
			}
			
		}
//		}
		}
}
