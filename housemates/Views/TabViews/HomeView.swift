//
//  HomeView.swift
//  housemates
//
import Foundation
import SwiftUI
import SwiftUITrackableScrollView


struct HomeView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var postViewModel : PostViewModel
    
    var body: some View {
        if let user = authViewModel.currentUser {
            
            VStack {
                // MARK: Vertical Scroll View
                ScrollView(.vertical) {
                    // MARK: Horizontal Housemates Scroll View
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            if let uid = user.id {
                                ForEach(userViewModel.getUserGroupmates(uid)) { user in
                                    NavigationLink(destination: HousemateProfileView(housemate: user)) {
                                        HousemateCircleComponent(housemate: user)
                                    }.buttonStyle(PlainButtonStyle())
                                }
                            }
                        }.padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    if let group_id = user.group_id {
                        ForEach(postViewModel.getPostsForGroup(group_id)) { post in
                            PostRowView(post: post, user: user).padding(.bottom, 5)
                        }
                    }
                }
            }
        }
    }
}
        
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel.mock())
            .environmentObject(UserViewModel.mock())
            .environmentObject(PostViewModel())

    }
}
