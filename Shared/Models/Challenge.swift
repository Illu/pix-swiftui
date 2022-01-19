//
//  Challenge.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-18.
//

import Foundation
import FirebaseFirestoreSwift

struct Challenge: Identifiable, Codable {
	var id: String
	var title: String
}
