//
//  HomeScreenView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct AuthContentView: View {
    @State private var selected: Tab = .house
    @State private var hideTabBar = false

    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        TabView {
            HomeView(hideTabBar: $hideTabBar)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            TaskBoardView(hideTabBar: $hideTabBar)
                .tabItem {
                    Image(systemName: "checkmark.square.fill")
                    Text("Tasks")
                }
            
            AmenityView(hideTabBar: $hideTabBar)
                .tabItem {
                    Image(systemName: "sofa.fill")
                    Text("Amentities")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }.onAppear {
            UITabBar.appearance().isHidden = hideTabBar
        }
    }
}



//#Preview {
//    AuthContentView()
//}
