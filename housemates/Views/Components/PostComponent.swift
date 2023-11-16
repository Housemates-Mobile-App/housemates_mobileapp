//
//  PostComponent.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import SwiftUI

struct PostComponent: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    let post : Post
    var body: some View {
        // MARK: Profile Picture for post user
        VStack {
            HStack(alignment: .top, spacing: 10) {
                let imageURL = URL(string: post.created_by.imageURLString ?? "")
                
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.leading, 1)
                } placeholder: {
        
                    // MARK: Default user profile picture
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.leading, 12)
                }
                
                
                VStack(alignment: .leading, spacing: 5) {
                    // MARK: Post Text Details
                    Text("**\(post.created_by.first_name) has completed the task:** \(post.task.name)")
                        .font(.system(size: 14))
                        .padding(.trailing)
                        .padding(.bottom, 30)
                   
                    // MARK: Comment, Like and Time compontnets
                    HStack(alignment: .bottom) {
                        // MARK: Like Button
                        Button(action: {
                            print("Like button tapped!")
                        }) {
                            Image(systemName: "heart")
                                .font(.system(size: 20))
                        }
                       
                        // MARK: Comment Button
                        Button(action: {
                            print("Comment button tapped!")
                        }) {
                            Image(systemName: "bubble.right")
                                .font(.system(size: 18))
                        }
                        Spacer()
                        
                        if let date = post.task.date_completed {
                            Text(date)
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    }
                       
                }
            }
            Divider()
        }

    }
}


struct PostComponent_Previews: PreviewProvider {
    static var previews: some View {
        PostComponent(post: PostViewModel.mockPost())
            .environmentObject(UserViewModel())
            .environmentObject(TaskViewModel())
    }
}
