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
        ZStack(alignment: .topLeading) {
            // MARK: Post images
            if let beforeImageURL = post.task.beforeImageURL,
               let afterImageURL = post.afterImageURL,
               let beforePostURL = URL(string: beforeImageURL),
               let afterPostURL = URL(string: afterImageURL){
                
                TabView {
                   // Display before image
                   PostPictureView(postURL: beforePostURL)
                   // Display after images
                   PostPictureView(postURL: afterPostURL)
               }
                
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
               .frame(width: 400, height: 490) // Set the width and height to the dimensions of PostPictureView
            }
           
            
            
            // MARK: Post Header
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 5) {
                    let imageURL = URL(string: post.created_by.imageURLString ?? "")
                    
                    // MARK: Profile Picture for post user
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    } placeholder: {
                        
                        // MARK: Default user profile picture
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9)) // Off-white color
                            .shadow(radius: 3)
                    }
                    
                    // MARK: user info, timestamp, and completed task info
                    if let date = post.task.date_completed {
                        let timestamp = String(postViewModel.getTimestamp(time: date) ?? "")
                        Text("**\(post.created_by.first_name)**")
                            .font(.custom("Lato", size: 16.5))
                            .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                            .padding(.top, 5)
                            .padding(.leading, 7)
                            .shadow(radius: 3)

                        
                        Text(" \(timestamp) ago")
                            .font(.custom("Lato", size: 16.5))
                            .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9)) // Off-white color
                            .padding(.top, 5)
                            .shadow(radius: 3)

                    }
                    
                }
                // MARK: Caption
                if let caption = post.caption {
                    Text(caption)
                        .font(.custom("Lato", size: 16.5))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .padding(.top, 5)
                        .padding(.leading, 2)
                        .shadow(radius: 3)
                }
                Spacer()
                
               
                // MARK: Bottom Section that has comment and like buttons
                HStack(alignment: .bottom, spacing: 12) {
                    likeButton(post: post, user: user)
                    
                    // MARK: Comment Button
                    commentButton(post: post, user: user)
    
                }.padding(.top, 100)
                .padding(.leading, 5)
                
            }
            .padding(.all, 15)
            .padding(.leading, 7)
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
                            .font(.system(size: 27))
                      
                    }
                } else {
                    Button(action: {
                        postViewModel.likePost(user: user, post: post)
                    }) {
                        Image(systemName: "heart")
                            .font(.system(size: 27))
                            .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                    }
                }
                
                // MARK: Like count
                
                Text(!post.liked_by.isEmpty ? String(post.num_likes) : " ")
                      .font(.custom("Lato", size: 18))
                      .foregroundColor(post.liked_by.contains(where: {$0 == user.id}) ? .red : Color(red: 0.95, green: 0.95, blue: 0.95))
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
                    .font(.system(size: 25))
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
            }
            
            if !post.comments.isEmpty {
                Text(String(post.num_comments))
                    .font(.custom("Lato", size: 18))
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                   
            }
        }.sheet(isPresented: $isCommentDetailSheetPresented) {
                CommentDetailView(post: post, user: user)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.automatic)
            }
        
    }
}



struct PostComponent_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(post: PostViewModel.mockPost(), user: UserViewModel.mockUser())            .environmentObject(PostViewModel.mock())


    }
}
