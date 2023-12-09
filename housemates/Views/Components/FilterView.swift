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
  let lightGray = Color(red: 0.945, green: 0.945, blue: 0.945)
  let darkGray = Color(red: 0.404, green: 0.404, blue: 0.404)
    
  var body: some View {
      HStack(spacing: 5) {
        
        Button(action: {
          selected = "All Tasks"
        }){
          Text("All Tasks")
//            .font(.system(size: 12))
            .font(.custom("Lato-Bold", size: 12))
            .frame(maxWidth: 75, maxHeight: 15)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .foregroundColor(selected == "All Tasks" ? Color.white : darkGray)
            .background(selected == "All Tasks" ? deepPurple : lightGray)
            .cornerRadius(25)
        }
        
        Button(action: {
          selected = "Unclaimed"
        }){
          Text("Unclaimed")
            .font(.custom("Lato-Bold", size: 12))
//            .font(.system(size: 12))
            .frame(maxWidth: 75, maxHeight: 15)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .foregroundColor(selected == "Unclaimed" ? Color.white : darkGray)
            .background(selected == "Unclaimed" ? deepPurple : lightGray)
            .cornerRadius(25)
        }
        
        Button(action: {
          selected = "In Progress"
        }){
          Text("In Progress")
            .font(.custom("Lato-Bold", size: 12))
//            .font(.system(size: 12))
            .frame(maxWidth: 75, maxHeight: 15)
//            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .foregroundColor(selected == "In Progress" ? Color.white : darkGray)
            .background(selected == "In Progress" ? deepPurple : lightGray)
            .cornerRadius(25)
        }
        
        Button(action: {
          selected = "Completed"
        }){
          Text("Completed")
            .font(.custom("Lato-Bold", size: 12))
//            .font(.system(size: 12))
            .frame(maxWidth: 75, maxHeight: 15)
//            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .foregroundColor(selected == "Completed" ? Color.white : darkGray)
            .background(selected == "Completed" ? deepPurple : lightGray)
            .cornerRadius(25)
        }
      }.padding(.horizontal, 5)
      
  }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
      @State var selected: String = "All Tasks"
      FilterView(selected: $selected)
    }
}
