import SwiftUI

struct TaskDetailView: View {

  let user: User
  @EnvironmentObject var taskViewModel: TaskViewModel
  var taskName: String
  var taskDescription: String
//  @State private var showAlert = false
//  @State private var alertMessage = ""
 

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("Task Details")
          .font(.title)
          .fontWeight(.bold)
          
      
        
        Text(taskName)
        Text(taskDescription)
//        NewInputView(text: $taskName, title: "Task Name", placeholder: taskName)
//
//        // for task description
//        NewInputView(text: $taskDescription, title: "Task Description", placeholder: taskDescription)
        
        
        
       
      }
      
    }
//    .alert(isPresented: $showAlert) {
//      Alert(title: Text(alertMessage.isEmpty ? "Adding task..." : alertMessage))
//    }
//    .onAppear {
//      taskName = taskNameHardcoded
//    }
  }
  
  


  
//  struct TaskDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//      TaskDetailView(taskIconStringHardcoded: "trash.fill", taskNameHardcoded: "Clean Dishes",
//                  user: User(first_name: "Bob", last_name: "Portis", phone_number: "9519012", email: "danielfg@gmail.com", birthday: "02/02/2000"), selectedTab: .constant(0))
//      .environmentObject(TaskViewModel())
//    }
//  }
}
