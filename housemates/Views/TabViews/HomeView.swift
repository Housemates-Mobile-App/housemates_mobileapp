//
//  HomeView.swift
//  housemates
//
import SwiftUI
import SwiftUITrackableScrollView

struct HomeView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var postViewModel : PostViewModel
    
    let examples = ["asdf", "asdf", "asdf"]
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
                    }
                
                    // MARK - Main Scroll Component
                    ScrollView {
                        
                        // MARK - Horizontal Housemates Scroll View
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                if let uid = user.id {
                                    ForEach(userViewModel.getUserGroupmates(uid)) { mate in
                                        NavigationLink(destination: HousemateProfileView(housemate: mate)) {
                                            HousemateCircleComponent(housemate: mate)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        
                            // MARK - Feed Content
    //                        LazyVStack(spacing: 10) {
    //                            ForEach(posts) { post in
    //                                PostComponent(post: post)
    //                            }
    //                        }
                        }
                        
                        Spacer()
                        
                    }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel.mock())
            .environmentObject(UserViewModel())
    }
}
