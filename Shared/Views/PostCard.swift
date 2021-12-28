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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(username)")
                Spacer()
                Button(action: {print("tap ellipsis")}) { Image(systemName: "ellipsis").foregroundColor(ColorManager.primaryText) }
            }.padding(.bottom, 10)
            HStack {
                
            }
            .frame(maxWidth: .infinity, maxHeight: 300.0)
            .background(.gray)
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
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    
                Spacer()
            }
            .padding(.vertical, 5)
            HStack {
                Text("6 Feb 2021")
                    .fontWeight(.light)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                Spacer()
            }
        }
        .padding()
        .background(ColorManager.card)
        .cornerRadius(8)
    }
}

struct PostCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            PostCard(username: "Test username", likesCount: 2, comments: [])
            Spacer()
        }.background(.gray)
    }
}
