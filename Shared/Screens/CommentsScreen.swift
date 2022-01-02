//
//  CommentsScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-01.
//

import SwiftUI
import FirebaseFirestore

struct CommentsScreen: View {
    
    var postId: String
    
    @EnvironmentObject var session: SessionStore
    
    @State var comments: [Comment] = []
    @State var currentComment: String = ""
    @State var state: States = States.IDLE
    
    var db = Firestore.firestore()
    
    func loadData () {
        self.state = States.LOADING
        let docRef = self.db.collection("Posts").document(postId)
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print ("error: \(error.localizedDescription)")
                self.state = States.SUCCESS
            }
            else {
                if let document = document {
                    do {
                        let post = try document.data(as: Post.self)
                        self.comments = post?.comments ?? []
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
    
    func addComment () {
        if (self.currentComment != "" && session.session!.uid != "") {
            let textToSend = "\(self.currentComment)"
            self.currentComment = ""
            let updateReference = self.db.collection("Posts").document(postId)
            updateReference.updateData([
                "comments": FieldValue.arrayUnion(
                    [
                        ["text": textToSend,
                         "timestamp": Int(Date.currentTimeStamp),
                         "userRef": db.document("Users/\(self.session.session?.uid ?? "")")
                        ]
                    ]
                )
            ])
            self.loadData()
        }
    }
    
    func getPlaceholderText () -> String {
        if (session.session == nil) {
            return "You must login to comment"
        }
        if ($comments.count == 0) {
            return "Add the first comment..."
        }
        return "Add your comment..."
    }
    
    var body: some View {
        VStack {
            if (state == States.LOADING) {
                ProgressView()
            }
            if ($comments.count == 0 && state != States.LOADING) {
                Spacer()
                Empty()
                Spacer()
            }
            ScrollView {
                ForEach(comments, id: \.self) { comment in
                    CommentView(comment: comment, userRef: comment.userRef)
                }
            }
            HStack {
                TextField(getPlaceholderText(), text: $currentComment)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .submitLabel(.send)
                    .onSubmit {
                        addComment()
                    }
                    .disabled(session.session == nil)
            }
            .background(ColorManager.inputBackground)
            .cornerRadius(4.0)
            .overlay(
                RoundedRectangle(cornerRadius: 4.0)
                    .stroke(ColorManager.secondaryText, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadData()
        }
    }
}

struct CommentsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CommentsScreen(postId: "")
    }
}
