//
//  TaskBoardView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct TaskBoardView: View {
    var body: some View {
        @ObservedObject var taskViewModel: TaskViewModel
        @ObservedObject var authViewModel: AuthViewModel
        
        var body: some View {
            VStack {
                Text("Tasks for User: \(authViewModel.currentUser?.id ?? "")")
                    .font(.title)
                    .padding()
                
                List(taskViewModel.tasksForUser) { task in
                    TaskRowView(task: task)
                }
                
                Text("Tasks for Group: \(authViewModel.currentUser?.group_id ?? "")")
                    .font(.title)
                    .padding()
                
                List(taskViewModel.tasksForGroup) { task in
                    TaskRowView(task: task)
                }
            }
            .onAppear {
                // Fetch tasks for the logged-in user
                if let userID = authViewModel.currentUser?.id {
                    taskViewModel.fetchTasksForUser(userID: userID)
                }
                
                // Fetch tasks for the group
                if let groupID = authViewModel.currentUser?.group_id {
                    taskViewModel.fetchTasksForGroup(groupID: groupID)
                }
            }
        }
    }
}

//#Preview {
//    TaskBoardView()
//}
