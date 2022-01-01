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
    var loading: Bool?
    var withBackground: Bool? = false
    var width: CGFloat? = BUTTON_WIDTH
    
    var body: some View {
        HStack {
            if (loading == true) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: withBackground! ? ColorManager.screenBackground : ColorManager.secondaryText))
            } else {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(withBackground! ? ColorManager.screenBackground : ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(10.0)
        .frame(maxWidth: width)
        .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous).fill(withBackground! ?  ColorManager.accent : .clear))
        .overlay(
            RoundedRectangle(cornerRadius: 4.0)
                .stroke(ColorManager.secondaryText, lineWidth: withBackground! ? 0 : 1)
        )
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LargeButton(
                title: "Press me"
            )
            LargeButton(
                title: "Large multiline button\nLarge multiline button "
            )
            LargeButton(title: "I should not be displayed", loading: true)
            LargeButton(title: "I have a background!", withBackground: true)
            LargeButton(title: "I should not be displayed (but I should have a colored background :)", loading: true, withBackground: true)
            LargeButton(title: "Smol button", width: 150)
        }
    }
}
