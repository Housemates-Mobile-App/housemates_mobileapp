//
//  PostComponent.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import SwiftUI
import MCEmojiPicker
import CachedAsyncImage

struct PostRowView: View {
    @EnvironmentObject var postViewModel : PostViewModel
    @State private var isEmojiPopoverPresented: Bool = false
    @State var isCommentDetailSheetPresented = false
    @State private var selectedEmoji = "🍑" // Default value
    @State private var selectedTabIndex = 0 // Initial tab index
    @State private var reactionBar = false
    @State private var reactionDict: [String: [String]] = [:]


    let post : Post
    let user : User
    var body: some View {
        ZStack(alignment: .topLeading) {
            // MARK: Post images (after image is required but before image is optional)
            if let afterImageURL = post.afterImageURL,
               let afterPostURL = URL(string: afterImageURL) {

                if let beforeImageURL = post.task.beforeImageURL,
                   let beforePostURL = URL(string: beforeImageURL) {

                    TabView (selection: $selectedTabIndex) {
                        PostPictureView(postURL: beforePostURL)
                            .tag(0)
            
                        PostPictureView(postURL: afterPostURL)
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(width: 400, height: 490)
                } else {
                    PostPictureView(postURL: afterPostURL)
                        .frame(width: 400, height: 490)
                }
            }

            // MARK: Post Header
            VStack(alignment: .leading, spacing: 10) {
                NavigationLink (destination: PostDetailView(post: post, user: user)) {
                    HStack(alignment: .top, spacing: 5) {
                        let imageURL = URL(string: post.created_by.imageURLString ?? "")
                        
                        // MARK: Profile Picture for post user
                        CachedAsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .padding(.trailing, 3)
                        } placeholder: {
                            
                            
                            Circle()
                                .fill(
                                  LinearGradient(
                                      gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6), Color(red: 0.8, green: 0.8, blue: 0.8)]),
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing
                                  )
                                )
                                .frame(width: 35, height: 35)
                                .overlay(
                                    Text("\(post.created_by.first_name.prefix(1).capitalized+post.created_by.last_name.prefix(1).capitalized)")
                                  
                                      .font(.custom("Nunito-Bold", size: 17))
                                      .foregroundColor(.white)
                                )
                                .padding(.trailing, 3)

                        }
                        
                        // MARK: user info, timestamp, and completed task info
                        ZStack(alignment: .leading) {
                            
                            // MARK: Top text
                            HStack {
                                if let date = post.task.date_completed {
                                    let timestamp = String(postViewModel.getTimestamp(time: date) ?? "")
                                    Text("**\(post.created_by.first_name)**")
                                        .font(.custom("Lato", size: 16))
                                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                                        .shadow(radius: 1)
                                    
                                    Text("\(timestamp) ago")
                                        .font(.custom("Lato", size: 16))
                                        .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                                        .shadow(radius: 3)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.custom("Lato", size: 16))
                                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                                        .shadow(radius: 3)
                                }
                            }
                            
                            
                            // MARK: Bottom Text
                            if post.task.beforeImageURL == nil {
                                Text( "Completed:  \(post.task.name)")
                                    .font(.custom("Lato", size: 13.5))
                                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                                    .shadow(radius: 3)
                                    .offset(x: -3, y: 20)
                            } else {
                                Text(" \(selectedTabIndex == 0 ? "Before:" : "After:")  \(post.task.name)")
                                    .font(.custom("Lato", size: 13.5))
                                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                                    .shadow(radius: 3)
                                    .offset(x: -3, y: 20)

                            }
                        } .offset(y: -2)
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
                HStack {
                        commentButton(post: post, user: user).offset(x: 4, y: 2)
                        
                        Spacer()
                        
                        toggleReactionsButton(post: post, user: user)
                }.offset(y: -36)
            
            }
            .padding(.all, 15)
            .padding(.leading, 7)
            
        
            // MARK: Bottom Section for reactions
        
           VStack(spacing: 6) {
               ForEach(postViewModel.reactionDict(post: post).sorted(by: {if $0.value.count == $1.value.count {
                   return $0.key < $1.key // Sort by key (chronological order)
               } else {
                   return $0.value.count < $1.value.count
               } }), id: \.key) { emoji, users in
                   reactionButton(emoji: emoji, currUser: user, post: post)
                       .rotationEffect(.degrees(180))
               }
               Spacer()

           }.rotationEffect(.degrees(180)) // Invert the content
            .frame(maxWidth: .infinity, alignment: .trailing) // Align to the trailing edge
            .padding(.trailing, 20) // Adjust the position with padding
            .padding(.bottom, 89)
              

        }.frame(height: 525) // Set the height of the ZStack
    }
    
    private func toggleReactionsButton(post: Post, user: User) -> some View {
        Button(action: {
            self.isEmojiPopoverPresented.toggle()

        }) {
            Image(systemName: "face.smiling.inverse")
                .font(.system(size: 23))
                .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                .shadow(radius: 2)
        }.emojiPicker(
            isPresented: $isEmojiPopoverPresented,
            selectedEmoji: $selectedEmoji,
            arrowDirection: .down
        ).onChange(of: selectedEmoji) { newEmoji in
            postViewModel.addReactionAndReact(post: post, emoji: newEmoji, user: user)
        }.padding(.trailing, 12)
    }
    
    // MARK: Add reaction
    private func addReactionButton(post: Post, user: User) -> some View {
        
        Button(action: {
            self.isEmojiPopoverPresented.toggle()
        }) {
            Image(systemName: "plus")
                .font(.system(size: 20))
        }
        .padding(8)
        .padding(.leading, 5)
        .padding(.trailing, 5)
        .cornerRadius(15)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.gray).opacity(0.15))
        ).emojiPicker(
            isPresented: $isEmojiPopoverPresented,
            selectedEmoji: $selectedEmoji,
            arrowDirection: .down
        ).onChange(of: selectedEmoji) { newEmoji in
            postViewModel.addReactionAndReact(post: post, emoji: newEmoji, user: user)
        }
    }
    
    // MARK: Reaction button
    private func reactionButton(emoji: String, currUser: User, post: Post) -> some View {
        let numReacts = post.reactions.filter{ $0.emoji == emoji }.count
        let userReactedToPost = post.reactions.contains { $0.created_by.user_id == currUser.id && $0.emoji == emoji }
        let backgroundColor = userReactedToPost ? Color(.white).opacity(0.48) : Color(.white).opacity(0.13)
        
        return Button(action: {
                // If user has already reacted, show remove react button
                if userReactedToPost {
                        postViewModel.removeReactionFromPost(post: post, emoji: emoji, currUser: currUser)
                
                // If user has has not reacted, show react button
                } else {
                        postViewModel.reactToPost(post: post, emoji: emoji, currUser: currUser)
                }
                
            }) {
               
                    Text(emoji)
                    .font(.system(size: 18)).offset(x: 3)
                                                                                                                      
               
                    Text("\(numReacts)")
                        .padding(.trailing, 5)
                        .font(.custom("Lato", size: 15))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                
                    
            }.padding(6)

            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(backgroundColor)
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
                    if post.comments.count == 1 {
                        Text("View comment")
                            .font(.custom("Lato", size: 15))
                            .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                    } else {
                        Text("View all \(post.comments.count) comments")
                            .font(.custom("Lato", size: 15))
                            .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                    }
                } else {
                    Text("Add a comment...")
                        .font(.custom("Lato", size: 15))
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
        PostRowView(post: PostViewModel.mockPost(), user: UserViewModel.mockUser())
            .environmentObject(PostViewModel.mock())


    }
}
