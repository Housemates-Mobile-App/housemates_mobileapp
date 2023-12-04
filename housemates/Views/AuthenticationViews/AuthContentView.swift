//
//  HomeScreenView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct AuthContentView: View {
    @State var selection = 1

    var body: some View {
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

                DashboardView()
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
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

//#Preview {
//    AuthContentView()
//}
