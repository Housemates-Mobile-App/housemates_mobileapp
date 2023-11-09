//
//  AddTaskView.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 11/8/23.
//

import SwiftUI

struct AddTaskView: View {
    let user: User
    
    @Environment(\.presentationMode) var presentationMode
    var taskViewModel : TaskViewModel
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var priority: TaskPriority = .medium

    enum TaskPriority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
//    Alert(isPresented: $showAlert) {
//        if alertMessage.isEmpty {
//            Text("Adding task...")
//        } else {
//            Text(alertMessage)
//        }
//    }

    var body: some View {
        NavigationView {
            Form {
                InputView(text: $taskName, title: "Task Name", placeholder: "Enter task name")
                InputView(text: $taskDescription, title: "Description", placeholder: "Enter task description")
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Button(action: {
                    addTask()
                }) {
                    Text("Add Task")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle(Text("Add Task"), displayMode: .inline)
        }
        .alert(isPresented: $showAlert) {
            if alertMessage.isEmpty {
                return Alert(title: Text("Adding task..."))
            } else {
                return Alert(title: Text(alertMessage))
            }
        }
    }
    
    private func addTask() {
        guard !taskName.isEmpty && !taskDescription.isEmpty else {
            alertMessage = "Task name or description cannot be empty."
            showAlert = true
            return
        }
        
        
        print("Task Name: \(taskName)")
        print("Task Description: \(taskDescription)")
        print("Priority: \(priority.rawValue)")
        
        let newTask = housemates.task(
            name: taskName,
            group_id: user.group_id ?? "",
            user_id: user.id,
            description: taskDescription,
            status: "unclaimed",
            date_started: nil,
            date_completed: nil,
            priority: priority.rawValue
        )
        
        if taskViewModel.tasks.contains(where: { $0.name == newTask.name }) {
            alertMessage = "Task already exists."
            showAlert = true
            return
        } else{
            taskViewModel.create(task: newTask)
        }
        
        alertMessage = "Task added successfully."
        showAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Delay the dismissal for 2 seconds (you can adjust the duration)
            showAlert = false
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    
}


//#Preview {
//    AddTaskView()
//}
