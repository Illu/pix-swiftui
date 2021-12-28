//
//  Comment.swift
//  pix (iOS)
//
//  Created by Maxime Nory on 2021-12-28.
//

import Foundation
import FirebaseFirestore

struct Comment: Codable {
    var text: String
    var timestamp: Int
    var userRef: DocumentReference
}
