//
//  RoundedAvatar.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-01.
//

import SwiftUI
import CachedAsyncImage

struct RoundedAvatar: View {
    
    @EnvironmentObject private var images: ImagesStore
    
    var name: String?
    var url: String? // sometimes this component is used in a context where it does not have access to the ImagesStore. with url, it can display the avatar directly from the URL instead.
    var size: CGFloat? = 50
    
    func getAvatarUrl () -> String {
        if (url == nil) {
            return images.avatars.first(where: {$0.name == name})?.url ?? ""
        } else {
            return url!
        }
    }
    
    var body: some View {
        if (name != nil || url != nil) {
            CachedAsyncImage(
                url: URL(string: getAvatarUrl()),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                },
                placeholder: {
                    ProgressView()
                        .frame(width: size, height: size)
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
