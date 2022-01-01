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
                    let category = "\(imageName)"
                    let avatar = Avatar(name: imageName, cloudPath: item, category: category, url: URL!.absoluteString)
                    self.avatars.append(avatar)
                }
            }
        }
    }
}
