//
//  TaskView.swift
//  housemates
//
//  Created by Bernard Sheng on 11/2/23.
//

import SwiftUI

struct TaskView: View {
    let task: task
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
    @Environment(\.editMode) private var editMode
    
//  now takes in a user
    let user: User
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.headline)

                if task.status == .done {
                Text(task.date_completed ?? "BUG ?")
              }
              
              else {
                Text("Priority: " + task.priority)
                    .font(.subheadline)
              }
                
            }
            
            Spacer()
          
//          environment variable edit mode, if clicked from anywhere, the status can be extracted as a wrapped value, defined above
          if editMode?.wrappedValue == .active {

              Button(action: {
                taskViewModel.destroy(task: task)
              }) {
                Text("Delete")
                  .foregroundColor(.white)
                  .padding(.horizontal)
                  .padding(.vertical, 4)
                  .background(Color.red)
                  .cornerRadius(8)
              }
            }
            // Based on task status display button or label
            switch task.status {
            case .done:
                Label("DONE", systemImage: "checkmark.circle.fill")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.green)
              
            case .inProgress:
//              if task is the useres own, they should be able to mark as done
              if taskViewModel.isMyTask(task: task, user_id: user.id ?? "") {

                Button(action: {
                  taskViewModel.completeTask(task: task)
                }) {
                  Text("DONE")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .cornerRadius(8)
                  
                  
                }
              }
              
              else {
                Label("IN PROGRESS", systemImage: "timer")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.blue)
                    .textCase(.uppercase)
              }
                
            case .unclaimed:
                Button(action: {
                  taskViewModel.claimTask(task: task)
                    
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
//      TaskView()
//    }
//}
