//
//  AboutScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-09.
//

import SwiftUI

struct AboutScreen: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorManager.primaryText)
                    .frame(width: 100, height: 100)
                VStack {
                    Text("Pix")
                    Text(Bundle.main.releaseVersionNumber ?? "Unknown version")
                }
            }
            VStack {
                Text("Pix is blablabla")
            }
            Spacer()
        }
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
}
