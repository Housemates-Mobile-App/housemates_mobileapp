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
    @State private var selectedTab: String = "Feed"
    var body: some View {
        let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
        if let user = authViewModel.currentUser {
          VStack {
          
           
              
           
            HStack {
              
                Button(action: {
                    selectedTab = "Personal"
                }) {
                    Text("Personal")
                        .font(.custom("Nunito-Bold", size: 15))
                        .frame(minWidth: 50, minHeight: 25)
                        .foregroundColor(selectedTab == "Personal" ? .white : .gray)
                        .padding(5)
                        .background(selectedTab == "Personal" ? Color.blue : Color.clear)
                        .cornerRadius(10)
                }.padding()
              
              

                Button(action: {
                    selectedTab = "Feed"
                }) {
                    Text("Feed")
                        .font(.custom("Nunito-Bold", size: 15))
                        .frame(minWidth: 50, minHeight: 25)
                        .foregroundColor(selectedTab == "Feed" ? .white : .gray)
                        .padding(5)
                        .background(selectedTab == "Feed" ? Color.blue : Color.clear)
                        .cornerRadius(10)
                }.padding()
              
            }
          
           
            
            .padding(.horizontal)
            .cornerRadius(10)
            
            if (selectedTab == "Feed") {
              
              
              // MARK - Home Page Header
              HStack {
                Text("Housemates")
                  .font(.custom("Nunito-Bold", size: 24))
                  .padding()
                Spacer()
                
                // MARK - Button to see all housemates
                NavigationLink(destination: HomeView()) {
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
                    NavigationLink(destination: PostDetailView(post: post, user: user)) {
                      PostComponent(post: post, user: user)
                    }.buttonStyle(PlainButtonStyle())
                  }
                }
              }
              Spacer()
            }
            
            else {
           
              VStack {
                Text("hi these are your stats")
                Text("\(taskViewModel.getNumPendingTasksForUser(user.id!))")
                  .foregroundColor(deepPurple)
                  .font(.system(size: 32))
                  .bold()
                Text("Pending")
                  .font(.system(size: 12))
                }
                .padding(.horizontal)
                .frame(minWidth: 75, minHeight: 25)
              Spacer()


              
              
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
