//
//  EditorScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-30.
//

import SwiftUI

struct EditorScreen: View {
    var body: some View {
        VStack {
            Text("Editor")
            PixelEditor()
        }
    }
}

struct EditorScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditorScreen()
    }
}
