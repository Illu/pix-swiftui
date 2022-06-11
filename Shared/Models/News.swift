//
//  News.swift
//  pix
//
//  Created by Maxime Nory on 2022-03-09.
//

import Foundation
import FirebaseFirestore

struct News: Codable, Hashable {
	var desc: String
	var title: String
	var comments: [Comment]?
}
