//
//  HomeView.swift
//  housemates
//
import SwiftUI
import SwiftUITrackableScrollView

struct HomeView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    
    static let mockTask1 = housemates.task( name: "Josh Completed Cleaning the Floor (1)",
      group_id: "Test",
      user_id: "Test",
      description: "Test",
      status: .unclaimed,
      date_started: nil,
      date_completed: nil,
      priority: "Test")
    static let testPost1 = Post(id: "1", task: mockTask1, num_likes: 3, num_comments: 2)
    
    static let mockTask2 = housemates.task( name: "Sean Completed Washing the Dishes (2)",
      group_id: "Test",
      user_id: "Test",
      description: "Test",
      status: .unclaimed,
      date_started: nil,
      date_completed: nil,
      priority: "Test")
    static let testPost2 = Post(id: "2", task: mockTask2, num_likes: 4, num_comments: 3)
    
    static let mockTask3 = housemates.task( name: "Bob Completed Draining the Soap (3)",
      group_id: "Test",
      user_id: "Test",
      description: "Test",
      status: .unclaimed,
      date_started: nil,
      date_completed: nil,
      priority: "Test")
    static let testPost3 = Post(id: "3", task: mockTask3, num_likes: 3, num_comments: 10)
    
    let posts : [Post] = [
        testPost1,
        testPost2,
        testPost3
    ]
    
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationView {
                VStack {
                    HStack {
                         Text("Housemates")
                             .font(.system(size: 24))
                             .bold()
                             .padding(.leading, 20)
                        Spacer()
                     }
                    
                    ScrollView {
                        // Horizontal list for housemates
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(userViewModel.getUserGroupmates(user.id!)) { mate in
                                    NavigationLink(destination: HousemateProfileView(housemate: mate)) {
                                        HousemateCircleComponent(housemate: mate)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        // Scrollable main content feed
                        VStack(spacing: 10) {
                            ForEach(posts) { post in
                                PostComponent(post: post)
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
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel.mock())
            .environmentObject(UserViewModel())
    }
}
