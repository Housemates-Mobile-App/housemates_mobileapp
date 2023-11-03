//
//  TaskView.swift
//  housemates
//
//  Created by Bernard Sheng on 11/2/23.
//

import SwiftUI

struct TaskView: View {
  var unclaimed: Bool
  var inProgressOther: Bool
  var inProgressSelf: Bool
    var body: some View {
      HStack {
        VStack(alignment: .leading) {
          Text("Placeholder")
            .bold()
          
          if inProgressOther {
            Text("In Progress")
              .foregroundColor(.gray)
              
          }
          
          else if unclaimed {
            Text("Priority: High")
              .foregroundColor(.red)
          }
          else {
            Text("Assigned to you")
              .foregroundColor(.gray)
          }
        }
//      space between text and button
       
        
        Button(action: {}) {
          Text("Done")
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(
              RoundedRectangle(cornerRadius: 25)
                .stroke(.blue, lineWidth: 1)
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        
      }
      .frame(minWidth: 325)
      .frame(maxWidth: 325)
      .padding(20)
      .background(
        RoundedRectangle(cornerRadius: 15)
          .stroke(.black, lineWidth: 1)
      )
      
        
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
      TaskView(unclaimed: false, inProgressOther: true, inProgressSelf: false)
    }
}
