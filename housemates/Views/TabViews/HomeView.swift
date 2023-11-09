//
//  HomeView.swift
//  housemates
//
import SwiftUI

struct Housemate: Identifiable {
    let id: String
    let name: String
    let isHome: Bool
}

struct post: Identifiable {
    let id: String
    let userName: String
    let action: String
    let timeAgo: String
}

struct HomeView: View {
    // Sample data
    let housemates = [
        Housemate(id: "1", name: "Daniel", isHome: true),
        Housemate(id: "2", name: "Sean", isHome: false),
        Housemate(id: "3", name: "Sanmoy", isHome: true)
    ]
    
    let posts = [
        post(id: "1", userName: "Sanmoy", action: "Take out trash", timeAgo: "2 min ago"),
        post(id: "2", userName: "Sean", action: "Wash Dishes", timeAgo: "2 days ago"),
        post(id: "3", userName: "Bernard", action: "Replace paper towel roll", timeAgo: "3 days ago")
    ]
    
    var body: some View {
        VStack {
            // Search bar placeholder
            TextField("Search", text: .constant(""))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            // Horizontal list for housemates
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(housemates) { mate in
                        VStack {
                            // Profile image placeholder
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding(.bottom, 5)
                            
                            Text(mate.name)
                                .font(.caption)
                            Text(mate.isHome ? "At Home" : "Not Home")
                                .font(.caption)
                                .foregroundColor(mate.isHome ? .green : .red)
                        }
                        .frame(width: 80)
                        .padding(.vertical)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
