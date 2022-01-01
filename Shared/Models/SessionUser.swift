//
//  SessionUser.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-31.
//

import Foundation

class SessionUser {
    var uid: String
    var email: String?
    var displayName: String?

    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }

}
