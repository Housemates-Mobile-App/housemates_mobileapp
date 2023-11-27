//
//  PostComponent.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import SwiftUI

struct PostRowView: View {
    @EnvironmentObject var postViewModel : PostViewModel
    @State var isCommentDetailSheetPresented = false
    
    let post : Post
    let user : User
    var body: some View {
        // MARK: Profile Picture for post user
        VStack {
            HStack(alignment: .top, spacing: 10) {
                let imageURL = URL(string: post.created_by.imageURLString ?? "")
                
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                } placeholder: {
        
                    // MARK: Default user profile picture
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                }
                
                
                VStack(alignment: .leading, spacing: 5) {
                    // MARK: Post Text Details
                  HStack {
                  
//                    Text("group id\(post.group_id)")
                    Text("**\(post.created_by.first_name)** completed: **\(post.task.name)**")
                      .font(.custom("Lato", size: 15))
                      .padding(.trailing)
                    
                    Spacer()
                    if let date = post.task.date_completed {
                      
                      let timestamp = String(postViewModel.getTimestamp(time: date) ?? "")
                      Text(timestamp)
                        .font(.custom("Lato", size: 12))
                            .foregroundColor(.gray)
//                            .padding(.trailing)
//                            .padding(.bottom, 30)
                    }
                  }.padding(.bottom, 30)
                        
//                  if want to put date right under name, comment out this and remove hstack
//                    if let date = post.task.date_completed {
//
//                      let timestamp = String(postViewModel.getTimestamp(time: date) ?? "")
//                      Text(timestamp)
//                            .font(.footnote)
//                            .foregroundColor(.gray)
//                            .padding(.trailing)
//                            .padding(.bottom, 30)
//                    }
                   
                    // MARK: Comment, Like and Time compontnets
                    HStack(alignment: .bottom) {
                        likeButton(post: post, user: user)
                       
                        // MARK: Comment Button
                        commentButton(post: post, user: user)
                        
                        Spacer()
                      
//                      add a settings, more button
                        
                        
                    }
                       
                }
            }
        }
    }
    
    // MARK: Like / Unlike Button
    private func likeButton(post: Post, user: User) -> some View {
      HStack(spacing: 2.5) {
                // MARK: If user has liked post show unlike button else show like button
                if post.liked_by.contains(where: {$0 == user.id}) {
                    Button(action: {
                        postViewModel.unlikePost(user: user, post: post)
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                      
                    }.buttonStyle(PlainButtonStyle()) // Allows button on list view to be independent
                } else {
                    Button(action: {
                        postViewModel.likePost(user: user, post: post)
                    }) {
                        Image(systemName: "heart")
                            .font(.system(size: 20))
                    }.buttonStyle(PlainButtonStyle()) // Allows button on list view to be independent
                }
                
                // MARK: Like count
                
                Text(!post.liked_by.isEmpty ? String(post.num_likes) : " ")
                      .font(.custom("Lato", size: 12))
                      .foregroundColor(post.liked_by.contains(where: {$0 == user.id}) ? .red : .black)
                      .frame(minWidth: 10, alignment: .leading)
                
        }
    }
    
    // MARK: Comment Button
    private func commentButton(post: Post, user: User) -> some View {
      HStack(spacing: 2.5) {
            Button(action: {
                isCommentDetailSheetPresented = true
            }) {
                Image(systemName: "bubble.right")
                    .font(.system(size: 18))
            }.buttonStyle(PlainButtonStyle())
            
            if !post.comments.isEmpty {
                Text(String(post.num_comments))
                    .font(.custom("Lato", size: 12))
                   
            }
            Spacer()
        }.sheet(isPresented: $isCommentDetailSheetPresented) {
                CommentDetailView(post: post, user: user)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.automatic)
            }
        
        }
}



struct PostComponent_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(post: PostViewModel.mockPost(), user: UserViewModel.mockUser())

    }
}
