//
//  ContentView.swift
//  housemates
//
//  Created by Sean Pham on 10/31/23.
//

import SwiftUI

struct ContentView: View {
  @State private var selected: Tab = .house
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    @State private var selected: Tab = .house
      // Test to see if data can be loaded from firebase
     
    ZStack {
      VStack {
        TabView(selection: $selected) {
          switch (selected) {
          case .person:
              ProfileView()
            
          case .tasks:
             TaskBoardView()
            
          case .sofa:
              AmenityView()
            
          default:
              HomeScreenView()
          }

        }
      }
      VStack {
        Spacer()
        TabBarView(selected: $selected)
      }
      

//     @EnvironmentObject var authViewModel: AuthViewModel

//     var body: some View {
//         SwiftUI.Group {
//             if authViewModel.userSession != nil {
//                 HomeScreenView()
//             } else {
//                 LoginView()
//             }
//         }

//     }
      
     
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

