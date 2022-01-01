//
//  LargeButton.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-31.
//

import SwiftUI

/*
 Note: This is only the content to be used inside a Button.
 This is because we need to use this with the NavigationLink, which
 does not support having a Button as a child.
 */
struct LargeButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .padding(10.0)
            .frame(width: BUTTON_WIDTH)
            .foregroundColor(ColorManager.secondaryText)
            .overlay(
                RoundedRectangle(cornerRadius: 4.0)
                    .stroke(ColorManager.secondaryText, lineWidth: 1)
            )
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        LargeButton(
            title: "Press me"
        )
    }
}
