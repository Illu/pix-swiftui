//
//  PublishViewModel.swift
//  pix
//
//  Created by Maxime Nory on 2022-04-02.
//

import Foundation
import FirebaseFirestore

class PublishViewModel: ObservableObject {
	
	@Published var state = States.IDLE

	private var db = Firestore.firestore()
	
	func submitPost (userRef: DocumentReference, postData: PostData, description: String, tag: String?) {
		self.state = States.LOADING
		var document: DocumentReference? = nil
		print("pixels \(postData.pixels)")
		document = db.collection("Posts").addDocument(data: [
			"userRef": userRef,
			"user": [
				"avatar": "",
				"id": userRef.documentID,
				"displayName": ""
			],
			"data": [
				"backgroundColor": postData.backgroundColor,
				"pixels": postData.pixels.compactMap { ["color": $0.color] }
			],
			"desc": description,
			"likes": [],
			"likesCount": 0,
			"tag": tag ?? "",
			"timestamp": Int(Date.currentTimeStamp)
		]) { err in
			if let err = err {
				self.state = States.ERROR
			   print("Error adding document: \(err)")
		   } else {
			   self.state = States.SUCCESS
			   print("Document added! id \(document?.documentID)")
		   }
		}
	}
}
