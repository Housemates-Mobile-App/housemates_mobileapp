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
        VStack() {
          VStack(spacing: 0) {
                let imageURL = URL(string: post.created_by.imageURLString ?? "")
                
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                } placeholder: {
                    // MARK: Default user profile picture
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 65, height: 65)
                        .overlay(
                            Text("\(post.created_by.first_name.prefix(1).capitalized + post.created_by.last_name.prefix(1).capitalized)")
                              
                                .font(.custom("Nunito-Bold", size: 30))
                                .foregroundColor(.white)
                        )
                }
                // MARK: Post details header
                Text("**\(post.created_by.first_name)** completed **\(post.task.name)**")
                .font(.custom("Lato", size: 15))
            }
            
            Text(post.task.date_completed!)
                .padding(.bottom, 2)
                .font(.custom("Lato", size: 12))

                
            
            Text("**Description:** \(post.task.description)")
                .font(.custom("Lato", size: 15))
      
                .padding(.top, 2)
      
            
            Text("**Priority:** \(post.task.priority)")
                .font(.custom("Lato", size: 15))
               
                .padding(.top, 2)
            
            
            HStack {
                likeButton(post: post, user: user).foregroundColor(.black)
                Text("\(post.num_likes) Likes")
                  .font(.custom("Lato", size: 15))
                Spacer()
                Image(systemName: "bubble.left")
                Text("\(post.num_comments) Comments")
                  .font(.custom("Lato", size: 15))
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
                    .font(.custom("Lato", size: 15))
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

//#Preview {
//    PostDetailView(post: PostViewModel.mockPost(), user: UserViewModel.mockUser())
//}
