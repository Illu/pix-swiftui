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
        db.collection("Posts").addSnapshotListener { (querySnapshot, error ) in
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
}
