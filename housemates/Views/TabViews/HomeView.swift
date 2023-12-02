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
                // MARK: Header
                HStack {
                    Text("Housemates")
                        .font(.custom("Nunito-Bold", size: 26))
                        .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .padding(.horizontal)
                        .padding(.top)
                    Spacer()
                }
                
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
                            NavigationLink(destination: PostDetailView(post: post, user: user)) {
                                PostRowView(post: post, user: user)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [(icon: String, title: String)]
    @Namespace private var namespace
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.selectedTab = index
                    }
                }) {
                    VStack {
                      HStack {
                        Image(systemName: tabs[index].icon)
                        Text(tabs[index].title)
                          .font(.custom("Nunito-Bold", size: 15))
                      }
                     
                        if selectedTab == index {
                            deepPurple.frame(height: 2)
                                .matchedGeometryEffect(id: "tabIndicator", in: namespace)
                        } else {
                            Color.clear.frame(height: 2)
                        }
                    }
                }
                .foregroundColor(self.selectedTab == index ? deepPurple : .gray)
            }
        }
        .padding()
        .background(Color.white)
        
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
