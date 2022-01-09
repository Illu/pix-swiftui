//
//  Detail.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-09.
//

import SwiftUI

struct Detail: View {
	
	var postData: PostData
	var desc: String
	
	var body: some View {
		VStack {
			GeometryReader { geometry in
				PixelArt(data: postData, pixelSize: geometry.size.width / ART_SIZE)
				Text(desc)
					.foregroundColor(.white)
			}
		}
		.background(.black)
	}
}
