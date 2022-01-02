//
//  ProfileData.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-02.
//

import SwiftUI
import FirebaseFirestore

struct ProfileData: View {
    
    var userId: String
    var isCurrentSessionProfile = false
    
    @State var userData: UserData? = nil
    @State var userPosts = [Post]()
    var db = Firestore.firestore()
    
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
    
    func loadUserPosts () {
        self.userPosts = []
        self.db.collection("Posts")
            .whereField("user.id", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error ) in
                guard let documents = querySnapshot?.documents else {
                    print("User has no posts")
                    self.userPosts = []
                    return
                }
                
                documents.forEach { (queryDocumentSnapshot) in
                    do {
                        let post = try queryDocumentSnapshot.data(as: Post.self)
                        self.userPosts.append(post!)
                    }
                    catch {
                        print(error)
                        self.userPosts = []
                    }
                }
            }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            if (userData == nil) {
                ProgressView()
            } else {
                VStack(alignment: .leading){
                    HStack {
                        RoundedAvatar(name: userData?.avatar, size: 100)
                        VStack(alignment: .leading, spacing: 16) {
                            Text(userData?.displayName ?? "Name Error")
                                .font(.largeTitle)
                            Text("\($userPosts.count) Post\($userPosts.count != 1 ? "s" : "")")
                        }
                    }
                    if (isCurrentSessionProfile) {
                        NavigationLink("Edit Profile") {
                            EditProfile()
                        }
                    }
                    if (userPosts.count > 0) {
                        ScrollView{
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(userPosts, id: \.self.id) { post in
                                    PixelArt(data: post.data)
                                }
                            }
                        }
                    } else {
                        Empty()
                    }
                }.padding(16)
            }
        }.onAppear{
            if (userData == nil && userPosts.count == 0) {
                loadUserData()
                loadUserPosts()
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileData_Previews: PreviewProvider {
    static var previews: some View {
        ProfileData(userId: "")
    }
}