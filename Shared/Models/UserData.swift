//
//  UserData.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-01.
//

import Foundation
import FirebaseFirestoreSwift

struct UserData: Codable {
    @DocumentID var id: String?
    var avatar: String
    var displayName: String
    var tipped: Bool?
	var customAvatar: String?
    var badges: [String]?
}
