//
//  AppStore.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-02.
//

import Foundation
import AlertToast

class AppStore: ObservableObject {
   
    @Published var loginSheetVisible = false
    @Published var toastVisible = false
    @Published var toast: AlertToast = AlertToast(type: .regular, title: "")

    func showLoginSheet () {
        self.loginSheetVisible = true
    }
    
    func hideLoginSheet () {
        self.loginSheetVisible = false
    }
    
    func showToast (toast: AlertToast) {
        self.toastVisible = true
        self.toast = toast
    }
}
