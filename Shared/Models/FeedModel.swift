//
//  FeedModel.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import Foundation

final class FeedModel: ObservableObject {
    
    @Published var sortMethod: Sorting = .top
    
    func changeSorting(newSorting: Sorting) {
        sortMethod = newSorting
    }
}
