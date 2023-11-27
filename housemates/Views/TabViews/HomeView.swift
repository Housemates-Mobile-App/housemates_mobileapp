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
    @EnvironmentObject var taskViewModel : TaskViewModel
    @State private var selectedTab = 0
    var body: some View {
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    if let user = authViewModel.currentUser {
      
      VStack {
        HStack {
          Text("Housemates")
              .font(.custom("Nunito-Bold", size: 26))
             
              .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
              .padding(.horizontal)
              .padding(.top)
          Spacer()
        }
        
        
       
          
//          CustomTabBar(selectedTab: $selectedTab, tabs: [(icon: "person.3.fill", title: "Feed"), (icon: "person.fill", title: "Personal")])
         

        
        if (selectedTab == 0) {
//          // MARK - Home Page Header
//          HStack {
//            //                        Text("Housemates")
//            //                            .font(.custom("Nunito-Bold", size: 24))
//            //                            .padding()
//            //                        Spacer()
//
//            // MARK - Horizontal Housemates Scroll View
//            ScrollView(.horizontal, showsIndicators: false) {
//              HStack(spacing: 15) {
//                if let uid = user.id {
//                  ForEach(userViewModel.getUserGroupmates(uid)) { user in
//                    NavigationLink(destination: HousemateProfileView(housemate: user)) {
//                      HousemateCircleComponent(housemate: user)
//                    }.buttonStyle(PlainButtonStyle())
//                  }
//                }
//              }
//              .padding(.horizontal)
//            }
//          }

          //MARK - Feed Content
          List {
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
              
            }.offset(x: 0, y: -10)
            
//            added to make sure only shows for a specific group
            if let group_id = user.group_id {
              
          
            ForEach(postViewModel.getPostsForGroup(group_id)) { post in
              // Jank ass way to get arrow to disappear (Stick it in ZStack)
              ZStack {
                NavigationLink(destination: PostDetailView(post: post, user: user)) {
                }.opacity(0)
                PostRowView(post: post, user: user)
              }
            }
          }
            
          }.listStyle(InsetListStyle())
          
          Spacer()
        }
        else {
          Spacer()
        }
      }
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
