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
    @Environment(\.presentationMode) var presentationMode
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
                       .padding(.leading, 70)
                   

                   Spacer()

                   // MARK - Button for creating post
                   Button {
                            postViewModel.sharePost(user: user, task: task)
                            presentationMode.wrappedValue.dismiss()
                   } label: {
                       Text("Share")
                   }
                   .padding(.trailing)
                   .font(.system(size: 20))
                   
               }
            
            Divider()
            
            Spacer()
        }
        
    }
}

#Preview {
    AddPostView(task: TaskViewModel.mockTask(), user: UserViewModel.mockUser())
}
