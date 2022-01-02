//
//  PixelEditor.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-30.
//

import SwiftUI


struct HistoryItem {
    var index: Int
    var color: String
}

struct PixelEditor: View {
    
    var pixelSize = 10.0
    @State var history: [[Pixel]] = []
    
    @State private var pixelData = [Pixel](repeating: Pixel(color: "none"), count: Int(ART_SIZE * ART_SIZE))
    @State var currentColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    @State var currentTool: TOOLS = TOOLS.PENCIL
    @State var showGrid: Bool = true
    @State var menuMode: MENU_MODES = MENU_MODES.DRAW
    @State var backgroundColor: String = DEFAULT_EDITOR_BACKGROUND_COLOR
    
    
    func getPixelSize(screenWidth: CGFloat) -> Double {
        return (screenWidth / ART_SIZE)
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                PixelArt(
                    data: PostData(backgroundColor: backgroundColor, pixels: pixelData),
                    showGrid: showGrid,
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
                                
                                if (self.currentTool == TOOLS.PENCIL) {
                                    if (pixelData[arrayPosition].color != currentColor.toHexString()) {
                                        history.append(pixelData)
                                        if history.count > 10 {
                                            history.removeFirst()
                                        }
                                        self.pixelData[arrayPosition].color = currentColor.toHexString()
                                    }
                                }
                                if (self.currentTool == TOOLS.ERASER) {
                                    if (pixelData[arrayPosition].color != "none") {
                                        history.append(pixelData)
                                        if history.count > 10 {
                                            history.removeFirst()
                                        }
                                        self.pixelData[arrayPosition].color = "none"
                                    }
                                }
                                if (self.currentTool == TOOLS.BUCKET) {
                                    if (pixelData[arrayPosition].color != currentColor.toHexString()) {
                                        history.append(pixelData)
                                        if history.count > 10 {
                                            history.removeFirst()
                                        }
                                        self.pixelData = dropBucket(data: pixelData, dropIndex: arrayPosition, color: currentColor.toHexString(), initialColor: pixelData[arrayPosition].color, initialData: pixelData)
                                    }
                                }
                            }
                    )
            }
            .frame(maxWidth: 400, maxHeight: 400)
            HStack {
                Button("Draw") {
                    self.menuMode = MENU_MODES.DRAW
                }
                Button("Background") {
                    self.menuMode = MENU_MODES.BACKGROUND
                }
            }
            if (menuMode == MENU_MODES.DRAW) {
                HStack {
                    Button(action: {self.currentTool = TOOLS.PENCIL}) {
                        EditorButton(icon: "paintbrush.pointed", active: currentTool == TOOLS.PENCIL)
                    }.padding(.leading, 30)
                    Button(action: {self.currentTool = TOOLS.ERASER}) {
                        EditorButton(icon: "bandage", active: currentTool == TOOLS.ERASER)
                    }
                    Button(action: {
                        if (self.history.count > 0) {
                            self.pixelData = self.history.last!
                            self.history.removeLast()
                        }
                    }) {
                        EditorButton(icon: "arrow.uturn.backward", active: false, disabled: self.history.count <= 0)
                    }.disabled(self.history.count <= 0)
                    Button(action: {self.currentTool = TOOLS.BUCKET}) {
                        EditorButton(icon: "drop", active: currentTool == TOOLS.BUCKET)
                    }.padding(.trailing, 30)
                }
            } else if (menuMode == MENU_MODES.BACKGROUND) {
                Button("Show Grid") {
                    self.showGrid.toggle()
                }
            }
            LargeButton(title: "Change color palette")
            ColorPicker("", selection: $currentColor, supportsOpacity: false)
        }
    }
}


struct PixelEditor_Previews: PreviewProvider {
    static var previews: some View {
        PixelEditor()
    }
}
