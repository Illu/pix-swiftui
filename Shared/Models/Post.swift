//
//  Post.swift
//  pix (iOS)
//
//  Created by Maxime Nory on 2021-12-28.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var desc: String
    var likes: [String]
    var likesCount: Int
    var tag: String?
    var timestamp: Int
    var comments: [Comment]?
    var userRef: DocumentReference
    var data: PostData
    var user: User
}

struct PostData: Codable {
    var backgroundColor: String
    var pixels: [Pixel]
}

struct Pixel: Codable {
    var color: String
}
