//
//  RoundedAvatar.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-01.
//

import SwiftUI

struct RoundedAvatar: View {
    
    @EnvironmentObject var images: ImagesStore
    
    var name: String?
    var size: CGFloat? = 50
    
    func getAvatarUrl () -> String {
        return images.avatars.first(where: {$0.name == name})?.url ?? ""
    }
    
    var body: some View {
        if (name != nil) {
            AsyncImage(
                url: URL(string: getAvatarUrl()),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: size, maxHeight: size)
                        .clipShape(Circle())
                },
                placeholder: {
                    ProgressView()
                }
            )
        } else {
            Text("Image Error")
        }
    }
}

struct RoundedAvatar_Previews: PreviewProvider {
    static var previews: some View {
        RoundedAvatar()
    }
}
