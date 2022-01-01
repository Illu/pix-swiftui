//
//  PixelEditor.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-30.
//

import SwiftUI

struct PixelEditor: View {
    
    var pixelSize = 10.0
    
    @State private var pixelData = [Pixel](repeating: Pixel(color: "#ffffff"), count: Int(ART_SIZE * ART_SIZE))
    @State private var backgroundColor = DEFAULT_EDITOR_BACKGROUND_COLOR
    
    private var currentColor: String = "#BADA55"
    
    func getPixelSize(screenWidth: CGFloat) -> Double {
        return (screenWidth / ART_SIZE)
    }
    
    var body: some View {
        GeometryReader { geometry in
            PixelArt(
                data: PostData(backgroundColor: backgroundColor, pixels: pixelData),
                showGrid: true,
                pixelSize: getPixelSize(screenWidth: geometry.size.width)
            )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged {value in
                            let px = trunc(value.location.x / getPixelSize(screenWidth: geometry.size.width))
                            let py = trunc(value.location.y / getPixelSize(screenWidth: geometry.size.width))
                            let arrayPosition = Int(py * ART_SIZE + px)
                            if (arrayPosition + 1 > pixelData.count || arrayPosition < 0) {
                                return
                            }
                            if (pixelData[arrayPosition].color != currentColor) {
                                self.pixelData[arrayPosition].color = currentColor
                            }
                        }
                )
        }
        .frame(maxWidth: 400, maxHeight: 400)
    }
}


struct PixelEditor_Previews: PreviewProvider {
    static var previews: some View {
        PixelEditor()
    }
}
