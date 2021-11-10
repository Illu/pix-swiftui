//
//  PostCard.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI

struct PostCard: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Username")
                Spacer()
                Image(systemName: "ellipsis")
                    .foregroundColor(.black)
            }.padding(.bottom, 10)
            HStack {
                
            }
            .frame(maxWidth: .infinity, maxHeight: 300.0)
            .background(.gray)
            HStack {
                Image(systemName: "heart")
                    .foregroundColor(.black)
                Text("19")
                Image(systemName: "bubble.left")
                    .foregroundColor(.black)
                Text("4")
                Spacer()
            }
            .padding(.vertical, 5)
            HStack {
                Text("Pixelated Grogu 🛸💫")
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
        .background(Color.white)
        .cornerRadius(8)
    }
}

struct PostCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            PostCard()
            Spacer()
        }.background(Color.red)
    }
}
