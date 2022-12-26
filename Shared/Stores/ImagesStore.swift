//
//  ImagesStore.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-01.
//

import Foundation
import FirebaseStorage

class ImagesStore: ObservableObject {
   
    @Published var state = States.IDLE
    @Published var avatars = [Avatar]()
    
	func createImageReference (name: String, data: Data, completion: @escaping((String?) -> () )) {
		do {
			let storage = Storage.storage()
			let storageRef = storage.reference()
			let imageRef = storageRef.child("custom-avatars/\(name).jpg")
			
			imageRef.putData(data, metadata: nil) { (metadata, error) in
				guard metadata != nil else {
						return
					}

					storageRef.downloadURL { (url, error) in
						guard let urlStr = url else {
							completion(nil)
							return
						}
						let downloadUrl = (urlStr.absoluteString)
						completion(downloadUrl)
					}
				}
		}
//		let storage = Storage.storage()
//		let storageRef = storage.reference()
//
//		let imageRef = storageRef.child("custom-avatars/\(name).jpg")
//
//		let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
//		  imageRef.downloadURL { (url, error) in
//			guard let downloadURL = url else {
//				print("get downloadurl error!")
//			  return
//			}
//			  print("Done!, download URL is \(downloadURL)")
//			  return downloadURL
//		  }
//		}
		
	}
	
    func loadAvatarsURLs () {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let avatarsRef = storageRef.child("avatars")
        avatarsRef.listAll { (result, error)  in
            if error != nil {
                print("error retrieving avatar list")
            }
            for item in result.items {
                item.downloadURL { (URL, URLerror) in
                    if URLerror != nil {
                        print("error retrieving URL for \(item)")
                    }
                    var imageCategory = URL!.pathComponents[URL!.pathComponents.count - 1]
                    var imageName = URL!.pathComponents[URL!.pathComponents.count - 1]
                    if let dashRange = imageName.range(of: "-") {
                        // transform the image name (xxx-n.png) to the category (xxx)
                        imageCategory.removeSubrange(dashRange.lowerBound..<imageCategory.endIndex)
                    }
                    if let dotRange = imageName.range(of: ".") {
                        // transform the image name (xxx-n.png) to the name (xxx-n)
                        imageName.removeSubrange(dotRange.lowerBound..<imageName.endIndex)
                    }
                    let avatar = Avatar(name: imageName, cloudPath: item, category: imageCategory, url: URL!.absoluteString)
                    self.avatars.append(avatar)
                }
            }
        }
    }
}
