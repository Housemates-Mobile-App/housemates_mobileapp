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
    
    // MARK: https://www.hackingwithswift.com/forums/swiftui/custom-font-in-navigation-title-and-back-button/22989 To change stlye of navigationTitle
    
    init() {
        let appear = UINavigationBarAppearance()

        let atters: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Nunito-Bold", size: 26)!,
            .foregroundColor: UIColor(red: 0.439, green: 0.298, blue: 1.0, alpha: 1.0)
        ]
        
        appear.largeTitleTextAttributes = atters
        appear.titleTextAttributes = atters
        UINavigationBar.appearance().standardAppearance = appear
     }
    
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationView {
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
                }.navigationTitle("Housemates")
                 .navigationBarTitleDisplayMode(.inline)
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
