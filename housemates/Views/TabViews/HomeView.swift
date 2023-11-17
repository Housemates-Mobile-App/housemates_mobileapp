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
                            .frame(minWidth: 80, minHeight: 25)
                            .background(selectedTab == "Personal" ? Color.purple : deepPurple)
                            .cornerRadius(16)
                    }.buttonStyle(SwitchButtonStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        selectedTab = "Feed"
                    }) {
                        Text("Feed")
                            .font(.custom("Nunito-Bold", size: 15))
                            .frame(minWidth: 80, minHeight: 25)
                            .background(selectedTab == "Feed" ? Color.purple : deepPurple)
                        
                            .cornerRadius(16)
                    }.buttonStyle(SwitchButtonStyle())
                        .padding(.horizontal)
                    
                }.padding()
                    .cornerRadius(10)
                
                if (selectedTab == "Feed") {
                    // MARK - Home Page Header
                    HStack {
//                        Text("Housemates")
//                            .font(.custom("Nunito-Bold", size: 24))
//                            .padding()
//                        Spacer()
                        
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
}
        

struct SwitchButtonStyle: ButtonStyle {
    let lightPurple = Color(red: 0.439 * 1.5, green: 0.298 * 1.5, blue: 1.0 * 1.5)
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    let darkPurple = Color(red: 0.439 * 0.6, green: 0.298 * 0.6, blue: 1.0 * 0.6)
  
    func makeBody(configuration: Configuration) -> some View {
            ZStack {
                configuration.label
                    .font(.custom("Lato-Bold", size: 15))
                   
                    .background(configuration.isPressed ? Color.white : darkPurple)
                    .cornerRadius(16)

                configuration.label
                    .font(.custom("Lato-Bold", size: 15))
                    
                    .background(lightPurple)
                    .cornerRadius(16)
                    .offset(x: configuration.isPressed ? 0 : 0, y: configuration.isPressed ? 0 : -2)
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
