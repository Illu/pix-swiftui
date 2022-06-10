//
//  AppStore.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-02.
//

import Foundation
import AlertToast
import UIKit
import SwiftUI

class AppStore: ObservableObject {
   
    @Published var loginSheetVisible = false
    @Published var toastVisible = false
    @Published var toast: AlertToast = AlertToast(type: .regular, title: "")
    @Published var commentsSheetVisible = false
    @Published var commentsSheetPostId = ""
    @Published var postDetailsVisible = false
	@Published var postDetailsData: PostData? = nil
	@Published var currentEditorId = UUID() // used to reset the editor contents by changing this id
	
    private var haptic: UINotificationFeedbackGenerator
    
    init() {
        self.haptic = UINotificationFeedbackGenerator()
    }
    
    func showLoginSheet () {
        self.loginSheetVisible = true
    }
    
    func hideLoginSheet () {
        self.loginSheetVisible = false
    }
	
	func showPostDetails (postData: PostData) {
		self.postDetailsData = postData
		withAnimation(.easeInOut(duration: 0.5)) {
			self.postDetailsVisible = true
		}
	}
	
	func hidePostDetails () {
		withAnimation(.easeInOut(duration: 0.5)) {
			self.postDetailsVisible = false
		}
	}
    
    func showToast (toast: AlertToast) {
        // TODO: add other haptic feedback for different notifications
        self.haptic.notificationOccurred(.success)
        self.toastVisible = true
        self.toast = toast
    }
    
    func showCommentsSheet (postId: String) {
        self.commentsSheetVisible = true
        self.commentsSheetPostId = postId
    }
    
    func hideCommentsSheet () {
        self.commentsSheetVisible = false
        self.commentsSheetPostId = ""
    }
	
	func resetEditor () {
		self.currentEditorId = UUID()
	}
}
