//
//  NotificationItem.swift
//  pix
//
//  Created by Maxime Nory on 2022-12-16.
//

import SwiftUI

struct NotificationItem: View {
	
	var title: String
	var type: NotificationType
	
	func getIconName (type: NotificationType) -> String {
		switch(type) {
			case NotificationType.COMMENT:
				return "bubble.right"
			case NotificationType.LIKE:
				return "heart"
		}
	}
	
    var body: some View {
		HStack {
			Image(systemName: getIconName(type: type))
				.font(.system(size: 20))
				.padding(.trailing)
			Text(title)
		}
    }
}

struct NotificationItem_Previews: PreviewProvider {
    static var previews: some View {
		List {
			NotificationItem(title: "Max added a new comment to your post", type: NotificationType.COMMENT)
			NotificationItem(title: "Eyimac added a new comment", type: NotificationType.COMMENT)
			NotificationItem(title: "Alexander Pistolerov Liked your post", type: NotificationType.LIKE)
		}
    }
}
