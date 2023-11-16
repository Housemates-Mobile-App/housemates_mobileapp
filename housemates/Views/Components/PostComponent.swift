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
        // for image and divider
        VStack {
            HStack(alignment: .top, spacing: 10) {
                Image("danielFace")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.leading, 8)
                
                // for rest of stuff
                VStack(alignment: .leading, spacing: 5) {
                    //user name
//                    let userId = taskViewModel.getUserIdByTaskId(post.task.id ?? "") ?? ""
                    let firstName = userViewModel.getUserByID(userId)?.first_name ?? "User"
                    Text("@\(firstName)")
                        .bold()
                        .font(.system(size: 18))
                    //caption/description
                    Text("Hey guys! I finished \(post.task.name)")
                        .font(.system(size: 16))
             
                    VStack(spacing: 5) {
                        HStack(alignment: .bottom) {
                            Image(systemName: "heart")
                            Image(systemName: "bubble.right")
                            Spacer()
                        }
                        HStack(alignment: .bottom) {
                            Text("\(post.num_likes) likes")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Text("\(post.num_comments) comments")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("2 min ago")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                }
            }
            Divider()
        }

    }
}


struct PostComponent_Previews: PreviewProvider {
    static let mockTask = housemates.task( name: "wiping the dishes",
      group_id: "Test",
      user_id: "Test",
      description: "Test",
      status: .unclaimed,
      date_started: nil,
      date_completed: nil,
      priority: "Test")
    static let testPost1 = Post(, num_likes: 3, num_comments: 2)
    static var previews: some View {
        PostComponent(post:testPost1)
            .environmentObject(UserViewModel())
            .environmentObject(TaskViewModel())
    }
}
