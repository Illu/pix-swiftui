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
		var test: DocumentReference? = nil
		
		test = db.collection("Posts").addDocument(data: [
			"userRef": userRef,
			"data": FieldValue.arrayUnion([
				[
					"backgroundColor": postData.backgroundColor,
					"pixels": postData.pixels
				]
			]),
			"desc": description,
			"likes": FieldValue.arrayUnion([]),
			"likesCount": 0,
			"tag": tag ?? "",
			"timestamp": Int(Date.currentTimeStamp)
		]) { err in
			if let err = err {
				self.state = States.ERROR
			   print("Error adding document: \(err)")
		   } else {
			   self.state = States.SUCCESS
			   print("Document added! id \(test?.documentID)")
		   }
		}
	}
}
