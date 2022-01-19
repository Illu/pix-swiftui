//
//  Detail.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-09.
//

import SwiftUI

struct Detail: View {

	var post: Post
//	var postData: PostData?
//	var desc: String

	
	@State private var offset: CGSize = .zero

	func getMaxPixelSize (screenWidth: CGFloat) -> CGFloat {
		var maxWidth = 600.0
		if (screenWidth < maxWidth) {
			maxWidth = screenWidth
		}
		return maxWidth / ART_SIZE
	}

	var body: some View {
		ScrollView {
			VStack {
				GeometryReader { geometry in
					PixelArt(data: post.data, pixelSize: getMaxPixelSize(screenWidth: geometry.size.width))
						.frame(height: geometry.size.width)
					Text(post.desc)
						.foregroundColor(.white)
					CommentsScreen(postId: post.id!)
				}
			}
			
		}
		.navigationTitle("Details")
		.navigationBarTitleDisplayMode(.inline)
	}
}
