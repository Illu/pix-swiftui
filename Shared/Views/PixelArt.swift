//
//  PixelArt.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-28.
//

import SwiftUI

struct PixelArt: View {
    var data: PostData
    
    let columns = [GridItem](repeating: GridItem(.adaptive(minimum: PIXEL_SIZE, maximum: PIXEL_SIZE), spacing: 0), count: Int(ART_SIZE))
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<data.pixels.count) { index in
                Rectangle()
                    .fill(Color.init(hex: data.pixels[index].color) ?? Color.clear)
                   .frame(width: PIXEL_SIZE, height: PIXEL_SIZE)
            }
        }.frame(width: PIXEL_SIZE * ART_SIZE, height: PIXEL_SIZE * ART_SIZE)
            .background(Color.init(hex: data.backgroundColor) ?? Color.white)
    }
}

struct PixelArt_Previews: PreviewProvider {
    
    static var previews: some View {
        PixelArt(data: PostData(backgroundColor: "#E5E5E5", pixels: [
            Pixel(color: "#BADA55"),
            Pixel(color: "none"),
            Pixel(color: "#BADA55"),
        ]))
    }
}
