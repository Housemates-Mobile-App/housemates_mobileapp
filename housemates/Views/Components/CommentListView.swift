//
//  CommentListView.swift
//  housemates
//
//  Created by Sean Pham on 11/16/23.
//

import SwiftUI

struct CommentListView: View {
    let comment: Comment
    var body: some View {
        // MARK: Profile Picture for comment user
        HStack(alignment: .top, spacing: 10) {
            let imageURL = URL(string: comment.created_by.imageURLString ?? "")
            
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
    
                // MARK: Default user profile picture
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            
            
            VStack(alignment: .leading, spacing: 5) {
                // MARK: Comment Text Details
                Text("**\(comment.created_by.first_name)**  \(comment.date_created)")
                    .font(.system(size: 14))
                
                Text(comment.text).font(.system(size: 15))
            }
            Spacer()
        }
     
    }
}

#Preview {
    CommentListView(comment: PostViewModel.mockComment())
}
