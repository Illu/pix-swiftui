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
    var userRef: DocumentReference
    var likesCount: Int
    var comments: [Comment]
    var id: String
    var data: PostData
    var likes: [String]
	var timestamp: Int
    
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
        userRef.getDocument { document, error in
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
	
	func generateReadableDate (time: Int) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM d, yyyy"
		return formatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(time / 1000)) as Date)
	}
	
	func openComments () {
		app.showCommentsSheet(postId: id, authorId: userRef.documentID)
	}
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    RoundedAvatar(name: userData?.avatar ?? "", size: 40)
                    Text(userData?.displayName ?? "Unknown")
                }.onTapGesture {
                    self.showUserProfile = true
                }
                Spacer()
				if (session.isAdmin) {
					Text("🔨")
				}
                Menu {
					Button(action: {self.openComments()}) { HStack {Text("View comments"); Spacer(); Image(systemName: "text.bubble") }}
                    Button(action: {self.showUserProfile = true}) { HStack {Text("\(userData?.displayName ?? "Unknown") profile"); Spacer(); Image(systemName: "person") }}
                    Button(action: {print("tap")}) { HStack {Text("Report this post"); Spacer(); Image(systemName: "exclamationmark.shield") }}
                } label: {
                    Image(systemName: "ellipsis").foregroundColor(ColorManager.primaryText)
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 10))
                }
            }
            GeometryReader { geometry in
				HStack{}.onAppear{ self.cardWidth = geometry.size.width}
            }
            PixelArt(data: data, pixelSize: cardWidth / ART_SIZE)
				.onTapGesture(count: 2) {
					self.onLikePost()
				}
				.onTapGesture(count: 1) {
					self.openComments()
				}
            HStack {
                HStack {
					ZStack {
						Image(systemName: "heart.fill")
							.opacity(isLiked() ? 1 : 0)
							.scaleEffect(isLiked() ? 1.0 : 0.1)
							.animation(.linear(duration: 0.2), value: isLiked() ? 1 : 0)
						Image(systemName: "heart")
					}.foregroundColor(isLiked() ? .red : ColorManager.primaryText)
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
					self.openComments()
                }
                Spacer()
            }
            .padding(.top, 10)
            HStack {
                Text("\(desc ?? "No description 😢")")
					.font(.system(size: 14))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
				Spacer()
            }
            .padding(.vertical, 5)
            HStack {
				Text(generateReadableDate(time: timestamp))
                    .fontWeight(.light)
                    .font(.footnote)
                    .foregroundColor(ColorManager.secondaryText)
                Spacer()
            }.padding(.bottom, 10)
        }
		.padding(.all)
		.background(ColorManager.cardBackground)
        .cornerRadius(8)
        .onAppear{
            setLocalVariables()
            loadUserData()
        }
        .background(
			NavigationLink(destination: ProfileData(userRef: userRef, isCurrentSessionProfile: session.session?.uid == userRef.documentID), isActive: $showUserProfile){
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
//                PostCard(
//					userRef: DocumentReference(),
//                    likesCount: 2,
//                    comments: [],
//                    id: "", data: PostData(
//                        backgroundColor: "FF00FF",
//                        pixels: [
//                            Pixel(color: "#BADA55")
//                        ]
//                    ),
//                    likes: [],
//					timestamp: 0
//                )
//                PostCard(
//					userRef: DocumentReference(),
//                    likesCount: 2,
//                    comments: [],
//                    id: "", data: PostData(
//                        backgroundColor: "FF00FF",
//                        pixels: [
//                            Pixel(color: "#BADA55")
//                        ]
//                    ),
//                    likes: [],
//					timestamp: 0
//                )
            }
        }
    }
}
