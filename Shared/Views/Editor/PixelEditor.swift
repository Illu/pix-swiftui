//
//  PixelEditor.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-30.
//

import SwiftUI
import AlertToast

struct HistoryItem {
	var index: Int
	var color: String
}

struct PixelEditor: View {
	
	@EnvironmentObject var app: AppStore
	
	var pixelSize = 10.0
	@State var history: [[Pixel]] = []
	@State var showPalettesSheet = false
	@State private var showingPublishScreen = false
	@State private var pixelData = [Pixel](repeating: Pixel(color: "none"), count: Int(ART_SIZE * ART_SIZE))
	@State var currentTool: TOOLS = TOOLS.PENCIL
	@State var showGrid: Bool = true
	@State var menuMode: MENU_MODES = MENU_MODES.DRAW
	@State var backgroundColor: String = DEFAULT_EDITOR_BACKGROUND_COLOR
	@State var currentColorPalette: Palette = Palettes[0]
	@State var currentColor = Color(.clear)
	
	@State private var isDrawing = false // if the user is currently drawing (holding its finger on the canvas)
	
	func getPixelSize(screenWidth: CGFloat) -> Double {
		return (screenWidth / ART_SIZE).rounded()
	}
	
	func onSelectPalette(newPalette: Palette) {
		self.showPalettesSheet = false
		self.currentColorPalette = newPalette
		self.currentColor = Color(hex: newPalette.colors.first ?? "#000000") ?? Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
	}
	
	func onGoToNextStep () {
		if (pixelData.contains { $0.color != "none" }) {
			self.showingPublishScreen = true
		} else {
			app.showToast(toast: AlertToast(type: .systemImage("exclamationmark.triangle", Color.orange), subTitle: "You cannot submit an empty artwork!"))
		}
	}
	
	func addToHistory() {
		if (!isDrawing) {
			self.isDrawing = true
			history.append(pixelData)
			if history.count > 10 {
				history.removeFirst()
			}
		}
	}
	
	var body: some View {
		VStack {
			NavigationLink(destination: SubmitScreen(postData: PostData(backgroundColor: backgroundColor, pixels: pixelData)), isActive: $showingPublishScreen) {
				EmptyView()
			}
			GeometryReader { geometry in
				HStack {
					PixelArt(
						data: PostData(backgroundColor: backgroundColor, pixels: pixelData),
						showGrid: showGrid,
						pixelSize: getPixelSize(screenWidth: geometry.size.width)
					)
						.gesture(
							DragGesture(minimumDistance: 0)
								.onChanged { value in
									let px = trunc(value.location.x / getPixelSize(screenWidth: geometry.size.width))
									let py = trunc(value.location.y / getPixelSize(screenWidth: geometry.size.width))
									let arrayPosition = Int(py * ART_SIZE + px)
									if (arrayPosition + 1 > pixelData.count || arrayPosition < 0) {
										return
									}
									
									if (self.currentTool == TOOLS.PENCIL) {
										if (pixelData[arrayPosition].color != currentColor.toHexString()) {
											addToHistory()
											self.pixelData[arrayPosition].color = currentColor.toHexString()
										}
									}
									if (self.currentTool == TOOLS.ERASER) {
										if (pixelData[arrayPosition].color != "none") {
											addToHistory()
											self.pixelData[arrayPosition].color = "none"
										}
									}
									if (self.currentTool == TOOLS.BUCKET) {
										if (pixelData[arrayPosition].color != currentColor.toHexString()) {
											addToHistory()
											self.pixelData = dropBucket(data: pixelData, dropIndex: arrayPosition, color: currentColor.toHexString(), initialColor: pixelData[arrayPosition].color, initialData: pixelData)
										}
									}
								}
								.onEnded { value in
									self.isDrawing = false
								}
						)
				}.frame(width: geometry.size.width)
			}
			.frame(maxWidth: 400, maxHeight: 400)
			HStack {
				Button(action: {self.menuMode = MENU_MODES.DRAW}) {
					EditorButton(text: "Draw", active: self.menuMode == MENU_MODES.DRAW, width: 140, height: 30)
				}
				Button(action: {self.menuMode = MENU_MODES.BACKGROUND}) {
					EditorButton(text: "Background", active: self.menuMode == MENU_MODES.BACKGROUND, width: 140, height: 30)
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
				Button(action: {self.showGrid.toggle()}) {
					EditorButton(icon: "grid", active: showGrid)
				}
			}
			ScrollView(.horizontal) {
				HStack {
					ForEach(currentColorPalette.colors, id: \.self) { color in
						Circle()
							.strokeBorder(color.lowercased() == "#ffffff" ? Color.black : .clear, lineWidth: 1)
							.background(Circle().fill(Color(hex: color) ?? .clear))
							.onTapGesture {
								if (menuMode == MENU_MODES.DRAW) {
									withAnimation(.easeInOut(duration: 0.2)) {
										self.currentColor = Color(hex: color) ?? .clear
									}
								} else {
									withAnimation(.easeInOut(duration: 0.2)) {
										self.backgroundColor = color
									}
								}
							}
							.frame(width: 50, height: 50)
							.scaleEffect(currentColor == Color(hex: color.lowercased()) ? 1.2 : 1.0)
					}
				}.padding(.all, 16)
			}
			Button(action: {self.showPalettesSheet.toggle()}) {
				LargeButton(title: "Change color palette")
			}
		}
		.onAppear {
			self.currentColor = Color(hex: currentColorPalette.colors.first ?? "#000000") ?? Color.black
		}
		.toolbar {
			Button(action: {onGoToNextStep()}) {
				Image(systemName: "arrow.right")
			}
		}
		.sheet(
			isPresented: $showPalettesSheet,
			onDismiss: { self.showPalettesSheet = false }
		) {
			NavigationView {
				PaletteList(onSelectPalette: onSelectPalette)
					.navigationTitle("Color palettes")
					.toolbar {
						Button(action: {self.showPalettesSheet = false}) { Text("Cancel") }
					}
			}
		}
	}
}


struct PixelEditor_Previews: PreviewProvider {
	static var previews: some View {
		PixelEditor()
	}
}
