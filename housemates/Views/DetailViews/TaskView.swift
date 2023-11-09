//
//  TaskView.swift
//  housemates
//
//  Created by Bernard Sheng on 11/2/23.
//

import SwiftUI

//struct TaskView: View {
//    var task: task
//    var unclaimed: Bool
//    var inProgressOther: Bool
//    var inProgressSelf: Bool
//    var body: some View {
//      HStack {
//        VStack(alignment: .leading) {
//          Text("Placeholder")
//            .bold()
//          
//          if inProgressOther {
//            Text("In Progress: \(task.name)")
//              .foregroundColor(.gray)
//              
//          }
//          
//          else if unclaimed {
//            Text("Priority: High")
//              .foregroundColor(.red)
//          }
//          else {
//            Text("Assigned to you")
//              .foregroundColor(.gray)
//          }
//        }
////      space between text and button
//       
//        
//        Button(action: {}) {
//          Text("Done")
//            .padding(.vertical, 5)
//            .padding(.horizontal, 10)
//            .background(
//              RoundedRectangle(cornerRadius: 25)
//                .stroke(.blue, lineWidth: 1)
//            )
//            .frame(maxWidth: .infinity, alignment: .trailing)
//            
//        }
//        
//      }
//      .frame(minWidth: 325)
//      .frame(maxWidth: 325)
//      .padding(20)
//      .background(
//        RoundedRectangle(cornerRadius: 15)
//          .stroke(.black, lineWidth: 1)
//      )
//      
//        
//    }
//}

//enum TaskStatus: String {
//    case inProgress = "In Progress"
//    case done = "Done"
//    case unclaimed = "Unclaimed"
//}

struct TaskView: View {
    let task: task
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.headline)
                Text(task.status)
                    .font(.subheadline)
            }
            
            Spacer()
            
            // Based on task status display button or label
            switch task.status {
            case "done":
                Label("DONE", systemImage: "checkmark.circle.fill")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.green)
            case "inProgress":
                Label("IN PROGRESS", systemImage: "timer")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.blue)
            case "unclaimed":
                Button(action: {
                    // Action to claim the task
                }) {
                    Text("CLAIM")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            default:
                EmptyView()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

//struct TaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskView(task: task, unclaimed: false, inProgressOther: true, inProgressSelf: false)
//    }
//}
