//
//  CommentDetailView.swift
//  housemates
//
//  Created by Sean Pham on 11/17/23.
//

import SwiftUI

struct CommentDetailView: View {
    @EnvironmentObject var postViewModel : PostViewModel
    @State private var newComment: String = ""
    let post : Post
    let user : User
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Comments
            if post.comments.isEmpty {
                Spacer()
                HStack{
                    Spacer()
                    Text("No Comments Yet")
                    Spacer()
                }
            } else {
                    List {
                        ForEach(post.comments) { comment in
                            CommentListView(comment: comment)
                        }
                    }.listStyle(InsetListStyle())
            }
                
            
            
            Spacer()
            
            // MARK: Comment Input Section
            HStack {
                TextField("Add a comment...", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    postViewModel.addComment(user: user, text: newComment, post: post)
                    newComment = "" // Clear the input field after submission
                }) {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            .padding(.bottom)
            
        }.padding(.top)
    }
}

//#Preview {
//    CommentDetailView(post: PostViewModel.mockPost(), user: UserViewModel.mockUser())
//}
