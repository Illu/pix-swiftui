//
//  PaletteList.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-04.
//

import SwiftUI

struct PaletteList: View {
    
    var onSelectPalette: (Palette) -> Void
    
    var body: some View {
        VStack {
            List(Palettes.indices, id: \.self) { index in
                Section(header: Text(Palettes[index].name)) {
                    Button(action: {onSelectPalette(Palettes[index])}) {
                        HStack {
                            ForEach(Palettes[index].colors, id: \.self) { color in
                                Circle()
                                    .strokeBorder(color == "#FFFFFF" ? Color.black : .clear, lineWidth: 1)
                                    .background(Circle().fill(Color(hex: color) ?? .clear))
                            }
                        }
                    }
                }
            }.listStyle(InsetGroupedListStyle())
        }
    }
}

struct PaletteList_Previews: PreviewProvider {
    static var previewAction: (Palette) -> Void = { _ in }
    static var previews: some View {
        PaletteList(onSelectPalette: previewAction)
    }
}
