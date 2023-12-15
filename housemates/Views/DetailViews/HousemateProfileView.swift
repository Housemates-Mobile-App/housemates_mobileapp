


//
//  HousemateProfileView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/2/23.
//

import SwiftUI
import CachedAsyncImage


struct HousemateProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
//    @EnvironmentObject var friendInfoViewModel : FriendInfoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let housemate: User
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body: some View {
        let recentTasks = taskViewModel.getRecentCompletedTasksForUser(housemate.id ?? "")
        let imageSize = UIScreen.main.bounds.width * 0.25
        let componentOffset = UIScreen.main.bounds.height * 0.063
        
        ZStack(alignment: .topLeading) {
           
                
            VStack {
                ZStack {
                    // MARK: Wave Background
                    NewWave()
                        .fill(deepPurple)
                        .frame(height: UIScreen.main.bounds.height * 0.13)
                }

                // MARK: Profile Picture
                let imageURL = URL(string: housemate.imageURLString ?? "")
                
                CachedAsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: -UIScreen.main.bounds.width * 0.32 ,y: UIScreen.main.bounds.height * -0.018)
                } placeholder: {
                    // Default user profile picture
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6), Color(red: 0.8, green: 0.8, blue: 0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: imageSize, height: imageSize)
                        .overlay(
                            Text("\(housemate.first_name.prefix(1).capitalized + housemate.last_name.prefix(1).capitalized)")
                            
                                .font(.custom("Nunito-Bold", size: 40))
                                .foregroundColor(.white)
                        )
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: -UIScreen.main.bounds.width * 0.32 ,y: UIScreen.main.bounds.height * -0.018)
                }
                    
               
                // MARK: Task Card
                HStack(spacing: 17) {
                    VStack {
                        Text("Completed")
                            .font(.custom("Nunito", size: 15))
                            .frame(minWidth: 55)
                        Text("\(taskViewModel.getNumCompletedTasksForUser(housemate.user_id))")
                            .font(.system(size: 32))
                            .foregroundColor(deepPurple)
                            .bold()
                        
                    }
                    
                    Divider().frame(height: UIScreen.main.bounds.height * 0.07)
                    
                    VStack {
                        Text("Pending")
                            .font(.custom("Nunito", size: 15))
                            .frame(minWidth: 55)
                        Text("\(taskViewModel.getNumPendingTasksForUser(housemate.user_id))")
                            .foregroundColor(deepPurple)
                            .font(.system(size: 32))
                            .bold()
                       
                    }
                   
                }.offset(x: UIScreen.main.bounds.width * 0.16, y: -componentOffset * 1.8)
               
                Spacer()
            }.edgesIgnoringSafeArea(.top)
            // MARK: End Vstack
                
              
        
            // MARK: Housemate name
            VStack(alignment: .leading) { // Set alignment to .leading
         
                Text("\(housemate.first_name) \(housemate.last_name)")
                    .font(.custom("Nunito-Bold", size: 26))
                    .bold()
                 
                Text("@\(housemate.username)")
                    .font(.custom("Nunito-Bold", size: 16))
                    .foregroundColor(deepPurple)
               
            }.offset(y: UIScreen.main.bounds.height * 0.13)
                .padding(.leading, 27)
                
            let recentTasks = taskViewModel.getRecentCompletedTasksForUser(housemate.user_id)

            
       // MARK: Calendar Preview
       VStack {
           if (!recentTasks.isEmpty) {

               ScrollView(.horizontal, showsIndicators: false) {

                   HStack(spacing: 15){
                       ForEach(recentTasks) {task in
                           NavigationLink(destination: TaskDetailView(currUser: housemate, currTask:task)) {

                               taskCard(task: task, user: housemate)
                           }
                       }
                   }
               }
           }

           HStack {
               Text("\(housemate.first_name)'s Activity")
                   .font(.custom("Nunito-Bold", size: 21))
                   .bold()
               Spacer()
           }
           ZStack(alignment: .topLeading) {
               RoundedRectangle(cornerRadius: 16)
               //                                .foregroundColor(deepPurple.opacity(0.6))
                   .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                   .frame(width: UIScreen.main.bounds.width * 0.90,
                          height: UIScreen.main.bounds.height * 0.23)

               Text("Last 14 Days").padding()
                   .font(.custom("Nunito-Bold", size: 17))
                   .foregroundColor(.black)
                   .offset(y: -4)

               // cells for two weeks ago
               HStack(spacing: 5) {
                   ForEach((0..<7).reversed(), id: \.self) { dayIndex in
                       SmallSquare(dayOffset: dayIndex + 7, user: housemate)

                   }
               }
               .offset(x: componentOffset * 0.2, y: componentOffset * 0.80)

               // cells for one week ago
               HStack(spacing: 5) {
                   ForEach((0..<7).reversed(), id: \.self) { dayIndex in
                       SmallSquare(dayOffset: dayIndex, user: housemate)
                   }
               }
               .offset(x: componentOffset * 0.2, y: componentOffset * 2)

               // View all activity button
               NavigationLink(destination: CalendarView( user: housemate)) {

                   Text("View All")
                       .font(.custom("Lato-Bold", size: 16))
                       .foregroundColor(.black)
                       .padding(.all, 6)
                       .background(
                           RoundedRectangle(cornerRadius: 12)
                               .stroke(Color.black, lineWidth: 1)
                       )
               }.offset(x: UIScreen.main.bounds.width * 0.68, y: UIScreen.main.bounds.height * 0.011)



           }.offset(x: -UIScreen.main.bounds.width * 0.03,
                    y: -UIScreen.main.bounds.height * 0.015)


       }.offset(y: componentOffset * 3.5)
       .padding(.leading, 20)

       // MARK: END Calendar  Preview
       
    }.navigationBarBackButtonHidden(true)
     .navigationBarItems(leading: backButton())
     .onAppear {
         tabBarViewModel.hideTabBar = true
    }
}
    private func backButton() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size:18))
                    .bold()
                    .padding(.vertical)
            }
        }
    }

}

struct HousemateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        HousemateProfileView(housemate: UserViewModel.mockUser())
            .environmentObject(AuthViewModel())
            .environmentObject(TaskViewModel())
            .environmentObject(TabBarViewModel())
            .environmentObject(FriendInfoViewModel())
    }
}

// MARK: Recent Activity

