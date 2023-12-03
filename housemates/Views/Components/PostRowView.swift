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
            // MARK: Background Card
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                .frame(width: 380, height: 555) // Adjust the width and height as needed
                .padding(.leading, 10)
            
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
                NavigationLink (destination: PostDetailView(post: post, user: user).toolbar(.hidden, for: .tabBar)) {
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
                            
                            Image(systemName: "chevron.right")
                                .font(.custom("Lato", size: 16.5))
                                .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                                .padding(.top, 8)
                                .padding(.leading, 6)
                                .shadow(radius: 3)
                        }
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
                
                // MARK: Add or view comment button
                HStack(alignment: .bottom, spacing: 12) {
                    commentButton(post: post, user: user)
                }.padding(.bottom, 15)
                 .padding(.leading, 5)

                // MARK: Bottom Section for reactions
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(post.reactions.sorted(by: { $0.key < $1.key }), id: \.key) { emoji, users in
                            reactionButton(emoji: emoji, currUser: user, post: post)
                        }
                    }
                }
            }
            .padding(.all, 15)
            .padding(.leading, 7)
        }.frame(height: 555) // Set the height of the ZStack
    }
    
    // MARK: Reaction button
    private func reactionButton(emoji: String, currUser: User, post: Post) -> some View {
        Button(action: {
                if let users = post.reactions[emoji] {
                        if users.contains(where: { $0 == currUser.id }) {
                            postViewModel.removeReactionFromPost(post: post, emoji: emoji, currUser: currUser)
                    } else {
                            postViewModel.reactToPost(post: post, emoji: emoji, currUser: currUser)
                    }
                }
            }) {
               
                    Text(emoji)
                        .font(.system(size: 20))
                    if let users = post.reactions[emoji] {
                        if !users.isEmpty {
                            Text("\(users.count)")
                                .padding(.trailing, 5)
                                .font(.custom("Lato", size: 16))
                                .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                                .shadow(radius: 3)
                        }
                    }
            }.padding(8)
            .padding(.leading, 5)
            .padding(.trailing, 5)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill((post.reactions[emoji]?.contains(where: { $0 == currUser.id }))! ?
                        Color(red: 0.95, green: 0.95, blue: 0.95).opacity(0.50) :
                        Color(red: 0.95, green: 0.95, blue: 0.95).opacity(0.25))
            )
            .cornerRadius(15)
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
                if !post.comments.isEmpty {
                    Text(String("View comments"))
                        .font(.custom("Lato", size: 18))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                       
                } else {
                    Text(String("Add a comment..."))
                        .font(.custom("Lato", size: 18))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                }
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
