import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    let currUser: User
    let currTask: task
    
    var body: some View {
        let assigneeUserId = currTask.user_id ?? nil
        let assignee = assigneeUserId != nil ? userViewModel.getUserByID(assigneeUserId!) : nil
        let imageURL = URL(string: assignee?.imageURLString ?? "")
        
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Task Details")
                    .font(.custom("Lato-Bold", size: 18))
                    .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                    .padding(.bottom, 50)

                // make it dynamic.
                Image("dalle3")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 60, height: 60)
                
                Text(currTask.name)
                    .font(.custom("Lato-Bold", size: 18))
                Text("Claimed by \(assignee?.first_name ?? "Nobody")")
                    .font(.custom("Lato-Regular", size: 14))
                    .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
                
                AsyncImage(url: imageURL) { image in
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                } placeholder: {
                  // MARK: Default user profile picture
                  Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                }
                Divider()
                    .padding(.vertical, 10)
                
                Text("Description")
                    .font(.custom("Lato-Bold", size: 18))
                Text(currTask.description)
                    .font(.custom("Lato-Regular", size: 14))
                    .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
                Divider()
                    .padding(.vertical, 10)
                
                Text("Priority")
                    .font(.custom("Lato-Bold", size: 18))
                Text(currTask.priority)
                    .font(.custom("Lato-Regular", size: 14))
                    .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
                Divider()
                    .padding(.vertical, 10)
                
                Text("Recurrence")
                    .font(.custom("Lato-Bold", size: 18))
                //hardcoded, this data doesnt exist yet
                Text("Repeats Every Monday")
                    .font(.custom("Lato-Regular", size: 14))
                    .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
            }.padding()
                .padding(.vertical, 10)
            
        }
    }
}
  
  


  
struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(currUser: UserViewModel.mockUser(), currTask: TaskViewModel.mockTask())
            .environmentObject(TaskViewModel())
            .environmentObject(UserViewModel())
    }
}

