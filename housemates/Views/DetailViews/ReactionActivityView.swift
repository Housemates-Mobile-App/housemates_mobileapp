//
//  ReactionActivityView.swift
//  housemates
//
//  Created by Sean Pham on 12/7/23.
//

import SwiftUI
import CachedAsyncImage

struct ReactionActivityView: View {
    @EnvironmentObject var postViewModel : PostViewModel

    let reaction: Reaction
    let post: Post
    var body: some View {
        NavigationLink (destination: PostDetailView(post: post, user: reaction.created_by)) {
            HStack {
                let imageURL = URL(string: reaction.created_by.imageURLString ?? "")
                
                // MARK: Profile Picture for comment user
                CachedAsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 42, height: 42)
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
                        .frame(width: 42, height: 42)
                        .overlay(
                            Text("\(reaction.created_by.first_name.prefix(1).capitalized+reaction.created_by.last_name.prefix(1).capitalized)")
                            
                                .font(.custom("Nunito-Bold", size: 20))
                                .foregroundColor(.white)
                        )
                        .padding(.trailing, 3)
                    
                }
                let timestamp = String(postViewModel.getTimestamp(time: reaction.date_created) ?? "")
                
                Text("**\(reaction.created_by.first_name)** reacted: \(reaction.emoji)  to your post")
                    .font(.custom("Lato", size: 14))
                    .foregroundColor(.primary)
                + Text("  \(timestamp)")
                    .font(.custom("Lato", size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
                
                if let afterImageURL = post.afterImageURL,
                   let afterPostURL = URL(string: afterImageURL) {
                    CachedAsyncImage(url: afterPostURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 47, height: 47)
                            .cornerRadius(10)
                            .padding(.trailing, 6)
                            .clipped()
                        
                    } placeholder: {
                        
                        // MARK: Loading wheel as a placeholder
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .frame(width: 47, height: 47)
                            .padding(.trailing, 5)
                        
                    }
                    
                }
            }
        }.padding(.leading, 10)
            .padding(.all, 6)
    }
}

//#Preview {
//    ReactionActivityView(reaction: PostViewModel.mockReaction(), post: PostViewModel.mockPost())
//        .environmentObject(PostViewModel.mock())
//}
