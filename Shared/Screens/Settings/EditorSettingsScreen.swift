//
//  EditorSettingsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-12-25.
//

import SwiftUI

struct EditorSettingsScreen: View {
	@AppStorage("hideGrid") private var hideGrid = false
	@AppStorage("palette") private var palette = 0
	
	var body: some View {
		List{
			Section {
				HStack {
					Picker("Default color palette", selection: $palette) {
						ForEach(Palettes.indices, id: \.self) { index in
							Text(Palettes[index].name)
						}
					}
					.pickerStyle(.automatic)
				}
			}
			header: {
				Text("Color Palettes")
			}
			Section {
				Toggle("Hide pixel grid", isOn: $hideGrid)
			} header: {
				Text("Background")
			} footer: {
				Text("You will always be able to toggle the pixel grid on and off inside the editor.")
			}
		}.navigationTitle("Editor Settings")
    }
}

struct EditorSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditorSettingsScreen()
    }
}
