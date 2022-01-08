//
//  AppStore.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-02.
//

import Foundation
import AlertToast
import UIKit

class AppStore: ObservableObject {
   
    @Published var loginSheetVisible = false
    @Published var toastVisible = false
    @Published var toast: AlertToast = AlertToast(type: .regular, title: "")
    @Published var commentsSheetVisible = false
    @Published var commentsSheetPostId = ""
    
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
}
