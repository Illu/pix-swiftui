//
//  Notification.swift
//  pix
//
//  Created by Maxime Nory on 2022-12-16.
//

import Foundation

struct Notification: Codable, Identifiable {
	var id: UUID
	var type: NotificationType
	var title: String
	var timestamp: Int
	var postId: String
}

enum NotificationType : String, Codable {
	case COMMENT = "comment"
	case LIKE = "like"
}
