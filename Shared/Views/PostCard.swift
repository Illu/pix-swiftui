//
//  PostCard.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI
import FirebaseFirestore

struct PostCard: View {
    
    var desc: String?
    var username: String
    var userId: String
    var likesCount: Int
    var comments: [Comment]
    var data: PostData
    
    var db = Firestore.firestore()

    @State private var cardWidth: Double = 0.0
    @State private var userData: UserData?
    
    func loadUserData () {
        let docRef = self.db.collection("Users").document(userId)
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print ("error: \(error.localizedDescription)")
            }
            else {
                if let document = document {
                    do {
                        self.userData = try document.data(as: UserData.self)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                RoundedAvatar(name: userData?.avatar ?? "", size: 40)
                Text(userData?.displayName ?? username)
                Spacer()
                Button(action: {print("tap ellipsis")}) { Image(systemName: "ellipsis").foregroundColor(ColorManager.primaryText) }
            }.padding(.bottom, 10)
            GeometryReader { geometry in
                HStack{}.onAppear{ self.cardWidth = geometry.size.width}
            }
            PixelArt(data: data, pixelSize: cardWidth / ART_SIZE)
                .frame(width: cardWidth, height: cardWidth)
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
        .padding(16)
        .background(ColorManager.cardBackground)
        .cornerRadius(8)
        .frame(maxWidth: 400)
        .onAppear(perform: loadUserData)
    }
}

struct PostCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            Color(.gray)
            VStack {
                PostCard(
                    username: "Test username",
                    userId: "", likesCount: 2,
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
                    userId: "",
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
