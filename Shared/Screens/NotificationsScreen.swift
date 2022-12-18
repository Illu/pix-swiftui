//
//  NotificationsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-29.
//

import SwiftUI
import FirebaseFirestore

struct NotificationsScreen: View {

	@EnvironmentObject var session: SessionStore

	@State var state: States = States.IDLE

	var db = Firestore.firestore()

	func deleteNotifications () {
		db.collection("Inboxes").document(session.session!.uid).delete() { err in
			if let err = err {
			   print("Error removing document: \(err)")
		   } else {
			   print("Notifications cleared for inbox!")
			   session.clearNotifications()
		   }
		}
	}
	
    var body: some View {
		VStack {
			if (session.notifications.count == 0 && self.state != States.LOADING) {
				Spacer()
				Empty()
				Spacer()
			} else {
				List(session.notifications) { notification in
					NavigationLink(destination: DetailsScreen(postId: notification.postId)) {
						NotificationItem(title: notification.title, type: notification.type)
					}
				}
				.refreshable(action: { session.loadNotifications() })
			}
		}
		.toolbar {
			Button(action: { deleteNotifications() }) { Text("Clear") }.disabled(session.notifications.count == 0)
		}
		.navigationTitle("Notifications")
		.navigationBarTitleDisplayMode(.inline)
		.onAppear(perform: session.loadNotifications)
    }
}

struct NotificationsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsScreen()
    }
}
