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
    var id: String
    var data: PostData
    var likes: [String]
    
    var db = Firestore.firestore()

    @State private var showUserProfile = false
    @State private var cardWidth: Double = 0.0
    @State private var userData: UserData?
    @State private var localLikesCount: Int = 0
    @State private var localLikes: [String] = []
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var app: AppStore

    func setLocalVariables () {
        self.localLikes = likes
        self.localLikesCount = likesCount
    }
    
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
    
    func onLikePost () {
        let docRef = self.db.collection("Posts").document(id)
        let userId = session.session?.uid ?? nil
        if (userId != nil) {
            if (isLiked()) {
                self.localLikesCount -= 1
                self.localLikes.removeAll(where: {$0 == userId})
                docRef.updateData([
                    "likes": FieldValue.arrayRemove([userId!]),
                    "likesCount": FirebaseFirestore.FieldValue.increment(Int64(-1))
                ])
            } else {
                self.localLikesCount += 1
                self.localLikes.append(userId!)
                docRef.updateData([
                    "likes": FieldValue.arrayUnion([userId!]),
                    "likesCount": FirebaseFirestore.FieldValue.increment(Int64(1))
                ])
            }
        } else {
            app.showLoginSheet()
        }
    }
    
    func isLiked () -> Bool {
        return localLikes.contains(session.session?.uid ?? "")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    RoundedAvatar(name: userData?.avatar ?? "", size: 40)
                    Text(userData?.displayName ?? username)
                }.onTapGesture {
                    self.showUserProfile = true
                }
                Spacer()
                Menu {
                    Button(action: {app.showCommentsSheet(postId: id)}) { HStack {Text("View comments"); Spacer(); Image(systemName: "chevron.right") }}
                    Button(action: {self.showUserProfile = true}) { HStack {Text("\(userData?.displayName ?? username) profile"); Spacer(); Image(systemName: "chevron.right") }}
                    Button(action: {print("tap")}) { HStack {Text("Report this post"); Spacer(); Image(systemName: "exclamationmark.shield") }}
                } label: {
                    Image(systemName: "ellipsis").foregroundColor(ColorManager.primaryText)
                }
            }
            .padding(.top, 10)
            GeometryReader { geometry in
                HStack{}.onAppear{ self.cardWidth = geometry.size.width}
            }
            PixelArt(data: data, pixelSize: cardWidth / ART_SIZE)
                .frame(width: cardWidth, height: cardWidth)
            HStack {
                HStack {
                    Image(systemName: isLiked() ? "heart.fill" : "heart")
                        .foregroundColor(isLiked() ? .red : ColorManager.primaryText)
                    Text("\(localLikesCount)")
                }
                .padding(.trailing, 5)
                .onTapGesture {
                    self.onLikePost()
                }
                HStack {
                    Image(systemName: "bubble.left")
                        .foregroundColor(ColorManager.primaryText)
                    Text("\(comments.count)")
                }.onTapGesture {
                    app.showCommentsSheet(postId: id)
                }
                Spacer()
            }
            .padding(.top, 10)
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
            }.padding(.bottom, 10)
        }
        .cornerRadius(8)
        .frame(maxWidth: 400, minHeight: 400)
        .onAppear{
            setLocalVariables()
            loadUserData()
        }
        .background(
            NavigationLink(destination: ProfileData(userId: userId), isActive: $showUserProfile){
               EmptyView()
            }.hidden()
        )
    }
}

struct PostCard_Previews: PreviewProvider {
    static var previewAction : () -> Void = { }
    static var previews: some View {
        ScrollView {
            Color(.gray)
            VStack {
                PostCard(
                    username: "Test username",
                    userId: "", likesCount: 2,
                    comments: [],
                    id: "", data: PostData(
                        backgroundColor: "FF00FF",
                        pixels: [
                            Pixel(color: "#BADA55")
                        ]
                    ),
                    likes: []
                )
                PostCard(
                    username: "Test username",
                    userId: "",
                    likesCount: 2,
                    comments: [],
                    id: "", data: PostData(
                        backgroundColor: "FF00FF",
                        pixels: [
                            Pixel(color: "#BADA55")
                        ]
                    ),
                    likes: []
                )
            }
        }
    }
}
