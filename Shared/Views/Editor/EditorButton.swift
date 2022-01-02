//
//  EditorButton.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-02.
//

import SwiftUI

struct EditorButton: View {
    var icon: String
    var active: Bool
    var disabled: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(active ? ColorManager.accent : ColorManager.screenBackground)
                .frame(width: 100, height: 50)
            Image(systemName: icon)
                .foregroundColor(active ? .white : disabled ? ColorManager.secondaryText : ColorManager.primaryText)
        }
        
      
    }
}

struct EditorButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EditorButton(icon: "bandage", active: true)
            EditorButton(icon: "bandage", active: false)
        }
    }
}
