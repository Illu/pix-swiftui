//
//  EditorButton.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-02.
//

import SwiftUI

struct EditorButton: View {
    var icon: String?
    var text: String?
    var active: Bool
    var disabled: Bool = false
    var width: CGFloat = 50
	var height: CGFloat = 50
	
    var body: some View {
        ZStack {
            if (text != nil) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(active ? ColorManager.accent : ColorManager.screenBackground)
                    .frame(width: width, height: height)
				Text(text!)
					.fontWeight(.medium)
                    .foregroundColor(active ? .white : disabled ? ColorManager.secondaryText : ColorManager.primaryText)
            }
            if (icon != nil) {
                Circle()
                    .fill(active ? ColorManager.accent : ColorManager.screenBackground)
                    .frame(width: 50, height: 50)
                Image(systemName: icon!)
                    .foregroundColor(active ? .white : disabled ? ColorManager.secondaryText : ColorManager.primaryText)
            }
        }
    }
}

struct EditorButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EditorButton(icon: "bandage", active: true)
            EditorButton(icon: "bandage", active: false)
            EditorButton(text: "test", active: true, width: 200)
            EditorButton(text: "test", active: false, width: 200)
			EditorButton(text: "with custom height", active: true, width: 200, height: 30)
			EditorButton(text: "with custom height", active: false, width: 200, height: 30)
        }
    }
}
