//
//  FilterView.swift
//  housemates
//
//  Created by Bernard Sheng on 11/11/23.
//

import SwiftUI

struct FilterView: View {
  @Binding var selected: String
  let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
  var body: some View {
      HStack(spacing: 5) {
        
        Button(action: {
          selected = "All Tasks"
        }){
          Text("All Tasks")
            .font(.system(size: 12))
            .frame(maxWidth: 75, maxHeight: 15)
            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .foregroundColor(Color.white)
            .background(selected == "All Tasks" ? deepPurple : deepPurple.opacity(0.25))
            .cornerRadius(25)
        }
        
        Button(action: {
          selected = "Todo"
        }){
          Text("Todo")
            .font(.system(size: 12))
            .frame(maxWidth: 75, maxHeight: 15)
            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .foregroundColor(Color.white)
            .background(selected == "Todo" ? deepPurple: deepPurple.opacity(0.25))
            .cornerRadius(25)
        }
        
        Button(action: {
          selected = "Doing"
        }){
          Text("Doing")
            .font(.system(size: 12))
            .frame(maxWidth: 75, maxHeight: 15)
            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .foregroundColor(Color.white)
            .background(selected == "Doing" ? deepPurple : deepPurple.opacity(0.25))
            .cornerRadius(25)
        }
        
        Button(action: {
          selected = "Completed"
        }){
          Text("Completed")
            .font(.system(size: 12))
            .frame(maxWidth: 75, maxHeight: 15)
            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .foregroundColor(Color.white)
            .background(selected == "Completed" ? deepPurple : deepPurple.opacity(0.25))
            .cornerRadius(25)
        }
      }
      
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
      @State var selected: String = "All Tasks"
      FilterView(selected: $selected)
    }
}
