//
//  Avatar.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-01.
//

import Foundation
import FirebaseStorage

struct Avatar: Hashable{
    var name: String
    var cloudPath: StorageReference
    var category: String
    var url: String
}
