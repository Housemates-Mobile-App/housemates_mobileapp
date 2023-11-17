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
                
                // MARK - Home Page Header
                HStack {
                    Text("Housemates")
                         .font(.system(size: 24))
                         .bold()
                         .padding(.leading, 20)
                    Spacer()
                }
                
                // MARK - Horizontal Housemates Scroll View
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        if let uid = user.id {
                            ForEach(userViewModel.getUserGroupmates(uid)) { user in
                                NavigationLink(destination: HousemateProfileView(housemate: user)) {
                                    HousemateCircleComponent(housemate: user)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                //MARK - Feed Content
                List {
                    
                    ForEach(postViewModel.posts) { post in
                        // Jank ass way to get arrow to disappear (Stick it in ZStack)
                        ZStack {
                            NavigationLink(destination: PostDetailView(post: post, user: user)) {
                            }.opacity(0)
                            PostRowView(post: post, user: user)
                        }
                    }

                }.listStyle(InsetListStyle())
                
                Spacer()
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
