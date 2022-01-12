//
//  Detail.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-09.
//

import SwiftUI

struct Detail: View {
	
	var postData: PostData?
	var desc: String

	@EnvironmentObject var app: AppStore

	@State private var offset: CGSize = .zero

	func getMaxPixelSize (screenWidth: CGFloat) -> CGFloat {
		var maxWidth = 600.0
		if (screenWidth < maxWidth) {
			maxWidth = screenWidth
		}
		return maxWidth / ART_SIZE
	}
	
	var body: some View {
		VStack {
			if (postData != nil) {
				GeometryReader { geometry in
					PixelArt(data: postData!, pixelSize: getMaxPixelSize(screenWidth: geometry.size.width))
					Text(desc)
						.foregroundColor(.white)
				}
			}
		}
		.offset(x: offset.width, y: offset.height)
					.animation(.interactiveSpring(), value: offset)
					.simultaneousGesture(
						DragGesture()
							.onChanged { gesture in
								if (gesture.translation.width < 50 || gesture.translation.height < 50) {
									offset = gesture.translation
								}
							}
							.onEnded { _ in
								if (abs(offset.height) > 100 || abs(offset.width) > 100 ) {
									print("HIDE!")
									app.hidePostDetails()
								} else {
									offset = .zero
								}
							}
					)
		.background(.black)
	}
}
