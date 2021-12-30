//
//  PixelArt.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-28.
//

import SwiftUI

struct PixelArt: View {
    var data: PostData
    var showGrid = false
    var pixelSize = 10.0
    
    var body: some View {
        Canvas{context, size in
            // Draw the background
            let backgroundRect = CGRect(origin: .zero, size: size)
            context.fill(Path(backgroundRect), with: .color(Color.init(hex: data.backgroundColor) ?? Color.clear))
            
            // Draw each pixel
            for (index, pixel) in data.pixels.enumerated() {
                let y = (index / Int(ART_SIZE)) * Int(pixelSize)
                let x = (index % Int(ART_SIZE)) * Int(pixelSize)
                let pixelRect = CGRect(
                    origin: CGPoint(x: x, y: y),
                    size: CGSize(width: pixelSize, height: pixelSize)
                )
                let path = Path(pixelRect)
                if (showGrid) {
                    context.stroke(path, with: .color(Color.init(hex: DEFAULT_GRID_COLOR)!), lineWidth: 1)
                }
                context.fill(path, with: .color(Color.init(hex: pixel.color) ?? Color.clear))
            }
        }.frame(width: pixelSize * ART_SIZE, height: pixelSize * ART_SIZE)
    }
}

struct PixelArt_Previews: PreviewProvider {
    
    static var previews: some View {
        PixelArt(data: PostData(
            backgroundColor: "#E5E5E5",
            pixels: [
                Pixel(color: "#BADA55"),
                Pixel(color: "none"),
                Pixel(color: "#BADA55"),
            ]),
                 showGrid: false
        )
    }
}
