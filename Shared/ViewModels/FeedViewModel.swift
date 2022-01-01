//
//  FeedModel.swift
//  pix (iOS)
//
//  Created by Maxime Nory on 2021-12-28.
//

import Foundation
import FirebaseFirestore

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("Posts")
            .limit(to: 2)
            .addSnapshotListener { (querySnapshot, error ) in
            guard let documents = querySnapshot?.documents else {
                print("No documents in Posts")
                return
            }
            
            documents.forEach { (queryDocumentSnapshot) in
                do {
                    let post = try queryDocumentSnapshot.data(as: Post.self)
                    self.posts.append(post!)
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    /* TODO: Write a search function that store data in a new Published var "previewItems", that will contain both users and posts
     * The search results should be displayed on top of the homescreen, and on tap it should bring to the detail view for the post or the user
     */
}
