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
  private var fillIcon: String {
    selected.rawValue + ".fill"
  }
  
  var body: some View {
    VStack {
      HStack {
        ForEach(Tab.allCases, id: \.rawValue) { tab in
          Spacer()
          Image(systemName: selected == tab ? fillIcon: tab.rawValue)
            .scaleEffect(selected == tab ? 1.3 : 1.0)
            .foregroundColor(selected == tab ? .white : .black)
            .font(.system(size: 32))
            .onTapGesture {
              withAnimation(.easeIn(duration: 0.1)) {
                selected = tab
              }
            }
          
          Spacer()
        }
        
      }
      .frame(width: nil, height: 60)
      .background(.thinMaterial)
      .background(Color.purple)
      
      .cornerRadius(10)
      .padding()
    }
  }
    
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
      TabBar(selected: .constant(.house))
    }
}
