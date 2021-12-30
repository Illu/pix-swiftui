//
//  Empty.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-30.
//

import SwiftUI

struct Empty: View {
    
    var actionTitle: String?
    var action: (() -> Void)?
    
    var body: some View {
        VStack {
            Image("cactus")
                .resizable()
                .scaledToFit()
                .frame(width: 150.0, height: 150.0)
            Text("There's nothing to show here yet!")
                .foregroundColor(ColorManager.secondaryText)
                .padding(20.0)
            if (action != nil) && (actionTitle != nil) {
                Button(action: {
                    action!()
                }) {
                    Text(actionTitle!)
                        .frame(width: BUTTON_WIDTH)
                        .padding(10.0)
                        .foregroundColor(ColorManager.secondaryText)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4.0)
                                .stroke(ColorManager.secondaryText, lineWidth: 1)
                        )
                }
                .cornerRadius(4.0)
            }
        }
    }
}

struct Empty_Previews: PreviewProvider {
    static var previewAction : () -> Void = { }
    
    static var previews: some View {
        Empty()
        Empty(actionTitle: "Find out more", action: previewAction)
    }
}
