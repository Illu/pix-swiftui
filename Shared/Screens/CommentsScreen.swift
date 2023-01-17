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
	var authorId: String?
	var news = false
	
    var body: some View {
		CommentsView(postId: postId, authorId: authorId, news: news)
    }
}

struct CommentsScreen_Previews: PreviewProvider {
    static var previews: some View {
		CommentsScreen(postId: "")
    }
}
