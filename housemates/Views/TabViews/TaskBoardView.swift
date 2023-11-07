//
//  TaskBoardView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct TaskBoardView: View {
    var body: some View {
      VStack(alignment: .leading) {
        
        Text("Task Board")
          .font(.largeTitle)
          .padding(.bottom, 10)
        
          
        
        VStack(alignment: .leading) {
          Text("Daily")
            .font(.title)
          TaskView(unclaimed: false, inProgressOther: true, inProgressSelf: false)
          TaskView(unclaimed: true, inProgressOther: false, inProgressSelf: false)
        }
        VStack(alignment: .leading) {
          Text("Recurring")
            .font(.title)
          TaskView(unclaimed: false, inProgressOther: false, inProgressSelf: true)
          TaskView(unclaimed: false, inProgressOther: true, inProgressSelf: false)
        }
        Spacer()
        
      }
      
        
    }
}



struct TaskBoardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskBoardView()
    }
}
