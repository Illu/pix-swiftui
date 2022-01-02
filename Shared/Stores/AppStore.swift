//
//  AppStore.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-02.
//

import Foundation

class AppStore: ObservableObject {
   
    @Published var loginSheetVisible = false

    func showLoginSheet () {
        self.loginSheetVisible = true
    }
    
    func hideLoginSheet () {
        self.loginSheetVisible = false
    }
}
