//
//  PostCard.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI

struct PostCard: View {
    
    var desc: String?
    var username: String
    var likesCount: Int
    var comments: [Comment]
    var data: PostData
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(username)")
                Spacer()
                Button(action: {print("tap ellipsis")}) { Image(systemName: "ellipsis").foregroundColor(ColorManager.primaryText) }
            }.padding(.bottom, 10)
            PixelArt(data: data)
            HStack {
                Image(systemName: "heart")
                    .foregroundColor(ColorManager.primaryText)
                Text("\(likesCount)")
                Image(systemName: "bubble.left")
                    .foregroundColor(ColorManager.primaryText)
                Text("\(comments.count)")
                Spacer()
            }
            .padding(.vertical, 5)
            HStack {
                Text("\(desc ?? "Default Description")")
                    .font(.body)
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.leading)
                    
                Spacer()
            }
            .padding(.vertical, 5)
            HStack {
                Text("6 Feb 2021")
                    .fontWeight(.light)
                    .font(.footnote)
                    .foregroundColor(ColorManager.secondaryText)
                Spacer()
            }
        }
        .padding()
        .background(ColorManager.cardBackground)
        .cornerRadius(8)
        .buttonStyle(PlainButtonStyle())
    }
}

struct PostCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.gray)
            VStack {
            PostCard(
                username: "Test username",
                likesCount: 2,
                comments: [],
                data: PostData(
                    backgroundColor: "FF00FF",
                    pixels: [
                        Pixel(color: "#BADA55")
                    ]
                )
            )
            PostCard(
                username: "Test username",
                likesCount: 2,
                comments: [],
                data: PostData(
                    backgroundColor: "FF00FF",
                    pixels: [
                        Pixel(color: "#BADA55")
                    ]
                )
            )
            }
        }
    }
}
