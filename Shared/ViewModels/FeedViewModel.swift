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
    @Published var state = States.IDLE
    
    private var lastSnapshot: QueryDocumentSnapshot? = nil
    
    private var db = Firestore.firestore()
    
    func emptyList() {
        self.posts = []
    }
    
	func fetchData(maxTimestamp: Int64? = nil, byNew: Bool? = false, nextPage: Bool = false, challenge: String? = nil) {
        self.state = States.LOADING
        
        if (!nextPage) {
            self.lastSnapshot = nil
        }
        
        var collection = byNew == true ? (
            db.collection("Posts")
                .order(by: "timestamp", descending: true)
        ) : (
            db.collection("Posts")
                .order(by: "likesCount", descending: true)
                // here, we should have: .whereField("timestamp", isGreaterThan: maxTimestamp ?? 0)
                // but Firestore doesn't support a where query with an order on a different value,
                // so the timestamp filtering must happen on the client-side. :(
        )
        
		if (challenge != nil) {
			print("getting items with tag \(challenge)")
			collection = collection.whereField("tag", isEqualTo: challenge!)
		}
		
        if (nextPage && self.lastSnapshot != nil){
            collection = collection.start(afterDocument: lastSnapshot!)
        }
        
        collection
            .limit(to: PAGE_ITEMS)
            .getDocuments() { (querySnapshot, error ) in
            guard let documents = querySnapshot?.documents else {
                print("No documents in Posts")
                self.state = States.SUCCESS
                return
            }
                
            self.lastSnapshot = querySnapshot?.documents.last
            if (!nextPage) {
                self.emptyList()
            }
            documents.forEach { (queryDocumentSnapshot) in
                do {
                    let post = try queryDocumentSnapshot.data(as: Post.self)
                    self.posts.append(post!)
                }
                catch {
                    print(error)
                    self.state = States.ERROR
                }
            }
            self.state = States.SUCCESS
        }
    }
    
    /* TODO: Write a search function that store data in a new Published var "previewItems", that will contain both users and posts
     * The search results should be displayed on top of the homescreen, and on tap it should bring to the detail view for the post or the user
     */
}
