//
//  ActivityView.swift
//  housemates
//
//  Created by Sean Pham on 12/6/23.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var postViewModel : PostViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @Environment(\.presentationMode) var presentationMode: Binding
       
    var btnBack : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left") // set image here
                Text("Notifications")
                    .font(.custom("Nunito-Bold", size: 23))
            }
        }
    }
      
        
    let user: User
    var body: some View {
        let activities = postViewModel.getActivity(user: user)
        let postList = postViewModel.getPostListFromActivities(activities: activities)
        let activityList = postViewModel.getActivityListFromActivities(activities : activities)
        
        VStack(alignment: .leading, spacing: 10) {
            ScrollView(.vertical) {
                ForEach(Array(postList.enumerated()), id: \.offset) { index, post in
                    let activity = activityList[index]
                    if let comment = activity as? Comment {
                        CommentActivityView(comment: comment, post: post)
                    } else if let reaction = activity as? Reaction {
                        ReactionActivityView(reaction: reaction, post: post)
                    }
                }
                Spacer()
            }
        }.padding(.top, 5)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .onAppear {
            tabBarViewModel.hideTabBar = true
        }.onDisappear {
            withAnimation(.easeIn(duration: 0.2), {
                tabBarViewModel.hideTabBar = false
            })
        }
                
    }
}

#Preview {
    ActivityView(user: UserViewModel.mockUser())
        .environmentObject(PostViewModel.mock())
        .environmentObject(TabBarViewModel.mock())
}
