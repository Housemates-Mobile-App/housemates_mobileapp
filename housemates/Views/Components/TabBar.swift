//
//  TabBar.swift
//  housemates
//
//  Created by Bernard Sheng on 10/31/23.
// Referenced https://www.youtube.com/watch?v=vzQDKYIKEb8&ab_channel=Indently

import SwiftUI

enum Tab: String, CaseIterable {
  case house
  case tasks = "list.bullet.rectangle.portrait"
  case sofa
  case person

}

struct TabBar: View {
  @Binding var selected: Tab
  @Binding var hideTabBar: Bool
  private var fillIcon: String {
    selected.rawValue + ".fill"
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        ForEach(Tab.allCases, id: \.rawValue) { tab in
          Spacer()
          Image(systemName: selected == tab ? fillIcon: tab.rawValue)
            .scaleEffect(selected == tab ? 1.15 : 1.0)
            .foregroundColor(selected == tab ? .white : .black)
            .font(.system(size: 24))
            .padding(.top, 30)
            .onTapGesture {
              withAnimation(.easeIn(duration: 0.1)) {
                selected = tab
//                  hideTabBar = tab == .tasks
              }
            }
          Spacer()
        }
      }
      
      .frame(maxWidth: .infinity, minHeight: 25, maxHeight: 25)
      
      
      
     
    }.background(Color.mint)
   
  }
    
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selected: .constant(.house), hideTabBar: Binding.constant(false))
    }
}
