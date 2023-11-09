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
                        TaskBoardView(hideTabBar: $hideTabBar)
                        
                    case .sofa:
                        AmenityView(hideTabBar: $hideTabBar)
                    }
                }
//                TabBar(selected: $selected)
                if !hideTabBar {
                    TabBar(selected: $selected, hideTabBar: $hideTabBar)
                }
            }
        }
        .onAppear {
                UITabBar.appearance().isHidden = false
            }
    }
}



//#Preview {
//    AuthContentView()
//}
