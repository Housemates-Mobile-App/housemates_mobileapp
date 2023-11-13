//
//  HomeView.swift
//  housemates
//
import SwiftUI

struct post: Identifiable {
    let id: String
    let userName: String
    let action: String
    let timeAgo: String
}

struct HomeView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    
    let posts = [
        post(id: "1", userName: "Sanmoy", action: "Take out trash", timeAgo: "2 min ago"),
        post(id: "2", userName: "Sean", action: "Wash Dishes", timeAgo: "2 days ago"),
        post(id: "3", userName: "Bernard", action: "Replace paper towel roll", timeAgo: "3 days ago")
    ]
    
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationView {
                VStack {
                    // Search bar placeholder
                    TextField("Search", text: .constant(""))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    HStack {
                         Text("Housemates")
                             .font(.system(size: 30))
                             .bold()
                         Spacer()
                         NavigationLink(destination: AllHousematesView()) {
                             Text("See All")
                                 .padding()
                                 .background(RoundedRectangle(cornerRadius: 10).fill(.pink))
                                 .foregroundColor(.white)
                                 .font(.system(size: 15))
                         }
                     }
                    
                    // Horizontal list for housemates
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(userViewModel.getUserGroupmates(user.id!)) { mate in
                                NavigationLink(destination: HousemateProfileView(housemate: mate)) {
                                    VStack {
                                        // Profile image placeholder
//                                        Image(systemName: "person.crop.circle.fill")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 60, height: 60)
//                                            .padding(.bottom, 5)
                                        let imageURL = URL(string: mate.imageURLString ?? "")
                                        
                                        AsyncImage(url: imageURL) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .frame(width: 60, height: 60)
                                                .padding(.bottom, 5)
                                            
                                        } placeholder: {
                                
                                            // MARK: Default user profile picture
                                            Image(systemName: "person.circle")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .frame(width: 60, height: 60)
                                                .padding(.bottom, 5)
                                            
                                        }
                                        
                                        Text(mate.first_name)
                                            .font(.caption)
                                        Text(mate.is_home != nil ? (mate.is_home! ? "At Home" : "Not Home") : "Unknown")
                                            .font(.caption)
                                            .foregroundColor(mate.is_home != nil ? (mate.is_home! ? .green : .red) : .gray)
                                    }
                                    .frame(width: 80)
                                    .padding(.vertical)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    // Scrollable main content feed
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(posts) { post in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Image(systemName: "person.crop.circle")
                                        Text(post.userName).bold()
                                        Text("completed the task:")
                                        Text(post.action).bold()
                                    }
                                    HStack {
                                        Image(systemName: "heart")
                                        Image(systemName: "bubble.right")
                                        Spacer()
                                        Text(post.timeAgo)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Your custom tab bar here
                }
                .navigationTitle("Home")
                .navigationBarItems(trailing: Button(action: {
                    // Define the action for your notifications button
                }) {
                    Image(systemName: "bell")
                })
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    @EnvironmentObject var authViewModel : AuthViewModel
//    @EnvironmentObject var userViewModel : UserViewModel
//    static var previews: some View {
//        HomeView(authViewModel: _authViewModel, userViewModel: _userViewModel)
//    }
//}
