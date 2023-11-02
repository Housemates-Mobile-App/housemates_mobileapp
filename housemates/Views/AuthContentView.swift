//
//  HomeScreenView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct AuthContentView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @State private var selected: Tab = .house
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        // Test to see if data can be loaded from firebase
        ZStack {
            VStack {
                Spacer()
                
                TabView(selection: $selected) {
                    switch (selected) {
                    case .house:
                        HomeView()
                        
                    case .person:
                        ProfileView()
                        
                    case .tasks:
                        TaskBoardView()
                        
                    case .sofa:
                        AmenityView()
                    }
                }
                VStack {
                    Spacer()
                    TabBar(selected: $selected)
                }
            }
        }
    }
}


#Preview {
    AuthContentView()
}
