//
//  AddAmenityView.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 11/9/23.
//

import SwiftUI

struct AddAmenityView: View {
//    let amenity: Amentity
    var taskViewModel : TaskViewModel
    @Binding var hideTabBar: Bool

    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Text("AddAmenity")
//                InputView(text: $taskName, title: "Task Name", placeholder: "Enter task name")
//                InputView(text: $taskDescription, title: "Description", placeholder: "Enter task description")
                
                Button(action: {
                    addAmenity()
                }) {
                    Text("Add Amenity")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle(Text("Add Amenity"), displayMode: .inline)
        }
        .alert(isPresented: $showAlert) {
            if alertMessage.isEmpty {
                return Alert(title: Text("Adding amenity..."))
            } else {
                return Alert(title: Text(alertMessage))
            }
        }
        .onAppear {
            hideTabBar = true
        }
        .onDisappear {
            hideTabBar = false
        }
    }
    
    
    
    private func addAmenity() {
        return
//        guard !taskName.isEmpty && !taskDescription.isEmpty else {
//            alertMessage = "Task name or description cannot be empty."
//            showAlert = true
//            return
//        }
//        
//        let newAmenity = housemates.Amentity(
//            name: taskName,
//            group_id: user.group_id ?? "",
//            user_id: user.id,
//            description: taskDescription,
//            status: "unclaimed",
//            date_started: nil,
//            date_completed: nil,
//            priority: priority.rawValue
//        )
//        
//        if amenityViewModel.tasks.contains(where: { $0.name == newAmenity.name }) {
//            alertMessage = "Amenity already exists."
//            showAlert = true
//            return
//        } else{
//            amenityViewModel.create(task: newAmenity)
//        }
//        
//        alertMessage = "Amenity added successfully."
//        showAlert = true
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            // Delay the dismissal for 2 seconds (you can adjust the duration)
//            showAlert = false
//            presentationMode.wrappedValue.dismiss()
//        }
    }
}

//#Preview {
//    AddAmenityView()
//}
