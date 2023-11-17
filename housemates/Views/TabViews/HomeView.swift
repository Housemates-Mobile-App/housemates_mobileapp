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
    @Binding var hideTabBar: Bool
        
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationView {
                VStack {
                    
                    // MARK - Home Page Header
                    HStack {
                        Text("Housemates")
                             .font(.system(size: 24))
                             .bold()
                             .padding(.leading, 20)
                        Spacer()
                        
                        // MARK - Button to see all housemates
                        NavigationLink(destination: HomeView(hideTabBar: $hideTabBar)) {
                                Text("View All")
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.gray)
                                .cornerRadius(120)
                                .font(.headline)
                        }.padding()
                    }
                    
                    // MARK - Main Scroll Component
                    ScrollView {
                        
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
                    LazyVStack(spacing: 10) {
                        ForEach(postViewModel.posts) { post in
                            NavigationLink(destination: PostDetailView(hideTabBar: $hideTabBar, post: post, user: user)) {
                                PostComponent(hideTabBar: $hideTabBar, post: post, user: user)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(hideTabBar: Binding.constant(false))
            .environmentObject(AuthViewModel.mock())
            .environmentObject(UserViewModel.mock())
            .environmentObject(PostViewModel())

    }
}
