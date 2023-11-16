//
//  AddPostView.swift
//  housemates
//
//  Created by Sean Pham on 11/15/23.
//

import SwiftUI

struct AddPostView: View {
    let task: task
    let user: User
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var postViewModel: PostViewModel


    var body: some View {
        VStack {
                
               HStack {
                   // MARK - Back button
                   Spacer()
                   
                   // MARK - New post Header
                   Text("New post")
                       .font(.system(size: 24))
                       .bold()
                       .padding(.leading, 60)
                   

                   Spacer()

                   // MARK - Button for creating post
                   Button {
//                       let post = Post(task_id: task.id, group_id: user.group_id, user_id: user.id, num_likes: 0, num_comments: 0, liked_by: [], comments: [])
//                       postViewModel.create(post: post)
                   } label: {
                       Text("Share")
                   }
                   .padding(.trailing)
               }
            
            Divider()
            
            // MARK - Add Caption
            
            Spacer()
        }
        
    }
}

#Preview {
    AddPostView(task: TaskViewModel.mockTask(), user: UserViewModel.mockUser())
        .environmentObject(UserViewModel())
}
