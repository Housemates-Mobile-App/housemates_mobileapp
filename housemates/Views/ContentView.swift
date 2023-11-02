//
//  ContentView.swift
//  housemates
//
//  Created by Sean Pham on 10/31/23.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var groupRepository = GroupRepository()
  @State private var selected: Tab = .house
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  var body: some View {
      // Test to see if data can be loaded from firebase
     
    ZStack {
      VStack {
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
            
          default:
              HomeView()
            
            
          }

        }
      }
      VStack {
        Spacer()
        TabBar(selected: $selected)
      }
      
    }
      
     
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

