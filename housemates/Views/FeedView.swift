//
//  FeedView.swift
//  housemates
//
//  Created by Bernard Sheng on 11/5/23.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
      ZStack {
        VStack() {
         
          HStack {
            Image(systemName: "magnifyingglass")
            Text("Search Bar")
            Spacer()
          }.padding(.horizontal, 20)
         
          
            
          HStack {
            Text("Housemates")
            Spacer()
            Button(action: {}) {
              Text("See All")
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(
                  RoundedRectangle(cornerRadius: 25)
                    .stroke(.blue, lineWidth: 1)
                )
                
            }
          }.padding(.horizontal, 20)
          
          ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ProfileCardView()
                ProfileCardView()
                ProfileCardView()
            }
            .padding(.horizontal) // Add padding here to constrain within the screen bounds
          }
          .padding(.bottom, 25)
          ScrollView(.vertical, showsIndicators: false) {
            VStack() {
              FeedCardView()
              FeedCardView()
              FeedCardView()
            }
          }
          
        }
        
        VStack {
          Spacer()
          TabBar(selected: .constant(.house))
        }
        
      }
      
     
      
        
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
