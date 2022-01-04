//
//  CurrentChallengeCard.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-03.
//

import SwiftUI
import FirebaseStorage

struct CurrentChallengeCard: View {
    
    @State var challengeImageURL: URL? = nil
    
    func loadChallengeData() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.locale = Locale(identifier: "EN-en")
        let currentMonth = dateFormatter.string(from: now).lowercased()
        
        Storage.storage()
            .reference(withPath: "challenges/\(currentMonth).png")
            .downloadURL {url, error in
                if let error = error {
                    print("Error retriving challenge image URL: \(error)")
                } else {
                    self.challengeImageURL = url
                }
            }
        
    }
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            AsyncImage(url: challengeImageURL)
        }.onAppear(perform: loadChallengeData)
    }
}

struct CurrentChallengeCard_Previews: PreviewProvider {
    static var previews: some View {
        CurrentChallengeCard()
    }
}
