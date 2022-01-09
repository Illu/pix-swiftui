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
        ScrollView{
            VStack {
                if (userData == nil) {
                    ProgressView()
                } else {
                    VStack(alignment: .leading){
                        HStack {
                            RoundedAvatar(name: userData?.avatar, size: 120)
                            VStack(alignment: .leading) {
								Spacer()
								Text(userData?.displayName ?? "Username Error 😭")
									.fontWeight(.bold)
                                Text("\($userPosts.count) Post\($userPosts.count != 1 ? "s" : "")")
								Text("Badges").padding(.top, 2)
								Spacer()
                            }
						}.padding(.bottom, 10)
                        if (userPosts.count > 0) {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(userPosts, id: \.self.id) { post in
									NavigationLink(destination: Detail(postData: post.data, desc: post.desc)) {
                                        PixelArt(data: post.data)
											.cornerRadius(4)
                                    }
                                }
                            }
                        } else {
                            Empty()
                        }
                    }.padding(16)
                }
            }
        }.onAppear{
            loadUserData()
            if (userPosts.count == 0) {
                loadUserPosts()
            }
        }
        .navigationTitle(isCurrentSessionProfile ? "Your Profile" : "Profile")
		.navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if (isCurrentSessionProfile) {
                NavigationLink(destination: EditProfile()) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
    }
}

struct ProfileData_Previews: PreviewProvider {
    static var previews: some View {
        ProfileData(userId: "")
    }
}
