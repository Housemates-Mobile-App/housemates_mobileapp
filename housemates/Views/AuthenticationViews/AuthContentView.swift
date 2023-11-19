//
//  HomeScreenView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct AuthContentView: View {
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                TaskBoardView()
                    .tabItem {
                        Image(systemName: "checkmark.square.fill")
                        Text("Tasks")
                    }
                
                AmenityView()
                    .tabItem {
                        Image(systemName: "sofa.fill")
                        Text("Amentities")
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }
        }
    }
}



//#Preview {
//    AuthContentView()
//}
