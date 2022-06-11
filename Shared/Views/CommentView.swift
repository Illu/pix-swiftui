//
//  CommentView.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-01.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CommentView: View {
    var comment: Comment
    var userRef: DocumentReference
    
    @State var state: States = States.IDLE
    @State var userData: UserData? = nil
    
    func loadUser () {
        userRef.getDocument { document, error in
            if let error = error as NSError? {
                print ("error: \(error.localizedDescription)")
                self.state = States.SUCCESS
            }
            else {
                if let document = document {
                    do {
                        self.userData = try document.data(as: UserData.self)
                        self.state = States.SUCCESS
                    }
                    catch {
                        print(error)
                        self.state = States.ERROR
                    }
                }
            }
        }
    }
    
    func generateReadableDate () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(comment.timestamp / 1000)) as Date)
    }
    
    var body: some View {
            VStack {
                HStack {
                    RoundedAvatar(name: userData?.avatar ?? nil)
                    VStack {
                        Text(userData?.displayName ?? "")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(generateReadableDate())
                            .foregroundColor(ColorManager.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                }
                .padding(.all, 16)
                Text(comment.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
        
        .background(ColorManager.cardBackground)
        .cornerRadius(20)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .onAppear {
            loadUser()
        }
    }
}

//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView()
//    }
//}
