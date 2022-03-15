//
//  AvatarList.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-01.
//

import SwiftUI

struct AvatarList: View {
    
    var onSelectAvatar: (String) -> Void
    @EnvironmentObject var images: ImagesStore
    
    @State var categories = [String]()
    
    private func getCategories () {
        var categories = [String]()
        
        images.avatars.forEach {avatar in
            if (!categories.contains(avatar.category)) {
                categories.append(avatar.category)
            }
        }
        self.categories = categories
    }
    
    var body: some View {
        ScrollView {
            ForEach(categories, id: \.self) { category in
				Text(category.capitalized + "s")
					.fontWeight(.semibold)
					.padding(16)
					.frame(maxWidth: .infinity, alignment: .leading)
				ScrollView (.horizontal, showsIndicators: false) {
					HStack {
						ForEach(images.avatars.filter({ $0.name.contains(category) }), id: \.self) { avatar in
							RoundedAvatar(url: images.avatars.first(where: {$0.name == avatar.name})?.url ?? "", size: 75).onTapGesture { onSelectAvatar(avatar.name) }
						}
					}.padding(.horizontal, 16)
				}
            }
        }.onAppear(perform: getCategories)
    }
}

struct AvatarList_Previews: PreviewProvider {
    // This is dirty, I didn't want to work a lot for a dumb preview (sorry hihi)
    static var previewAction : (_ name: String) -> Void = { name in }
    static var previews: some View {
        AvatarList(onSelectAvatar: previewAction)
    }
}
