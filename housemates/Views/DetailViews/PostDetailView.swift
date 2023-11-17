//
//  PostDetailView.swift
//  housemates
//
//  Created by Sean Pham on 11/15/23.
//

import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject var postViewModel : PostViewModel
    @State private var newComment: String = ""
    let post : Post
    let user : User
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 10) {
                let imageURL = URL(string: post.created_by.imageURLString ?? "")
                
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.leading, 12)
                } placeholder: {
                    
                    // MARK: Default user profile picture
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.leading, 12)
                }
                // MARK: Post details header
                Text("**\(post.created_by.first_name)** completed the task: **\(post.task.name)**")
                    .font(.headline)
            }
            
            Text(post.task.date_completed!)
                .padding(.top, 2)
                .padding(.leading)
            
            Text("**Description:** \(post.task.description)")
                .font(.subheadline)
                .padding(.top, 2)
                .padding(.leading)
            
            Text("**Priority:** \(post.task.priority)")
                .font(.subheadline)
                .padding(.top, 2)
                .padding(.leading)
            
            HStack {
                likeButton(post: post, user: user).foregroundColor(.black)
                Text("\(post.num_likes) Likes")
                Spacer()
                Image(systemName: "bubble.left")
                Text("\(post.num_comments) Comments")
            }
            .padding()
            
            Divider()
            
            // MARK: Comments
            List {
                ForEach(post.comments) { comment in
                    CommentListView(comment: comment)
                }
            }.listStyle(InsetListStyle())
            
            
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
            
        }.toolbar(.hidden, for: .tabBar)
    }
    
    
    // MARK: Like / Unlike Button
    private func likeButton(post: Post, user: User) -> some View {
        HStack {
                // MARK: If user has liked post show unlike button else show like button
                if post.liked_by.contains(where: {$0 == user.id}) {
                    Button(action: {
                        postViewModel.unlikePost(user: user, post: post)
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                } else {
                    Button(action: {
                        postViewModel.likePost(user: user, post: post)
                    }) {
                        Image(systemName: "heart")
                            .font(.system(size: 20))
                    }
                }
        }
    }
}

#Preview {
    PostDetailView(post: PostViewModel.mockPost(), user: UserViewModel.mockUser())
}
