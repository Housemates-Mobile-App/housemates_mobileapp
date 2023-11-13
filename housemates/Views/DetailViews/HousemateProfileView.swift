//
//  HousemateProfileView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/2/23.
//

import SwiftUI

struct HousemateProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var taskViewModel : TaskViewModel
    let housemate: User
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                //image
                let imageURL = URL(string: housemate.imageURLString ?? "")
                
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .foregroundColor(.gray)
                        .padding(5)
                } placeholder: {
                    // Default user profile picture
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .foregroundColor(.gray)
                        .padding(5)
                }
                
                Text("\(housemate.first_name) \(housemate.last_name)")
                    .font(.system(size: 34))
                    .bold()
                    .foregroundColor(.white)
                
                let userStatus: String = {
                    if let isHome = housemate.is_home {
                        return isHome ? "home" : "away"
                    } else {
                        return "unknown"
                    }
                }()
                
                Text("\(housemate.first_name) is currently \(userStatus)")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                
                HStack(spacing: 20) {
                    HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Call", iconStr: "call-phone", urlScheme:"tel")
                    HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Text", iconStr: "message-1", urlScheme:"sms")
                }
            }
//            Link("Call or Message", destination: URL(string: "tel://" + housemate.phone_number)!)
//                        .foregroundColor(.blue)
//                        .font(.system(size: 18))
            
            VStack (alignment:.leading) {
                Text("Tasks")
                    .font(.system(size: 27))
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                HStack {
                    Text("COMPLETED")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                    Text("\(taskViewModel.getCompletedTasksForUser(housemate.id!).count)")
                        .font(.system(size: 27))
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                }
                
                Divider().foregroundColor(.white)
                
                HStack {
                    Text("PENDING")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                    Text("\(taskViewModel.getPendingTasksForUser(housemate.id!).count)")
                        .font(.system(size: 27))
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                }
                Divider().foregroundColor(.white)
            }
            
            Spacer()
        }.padding(.top, 50)
            .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.925, green: 0.863, blue: 1.0),
                Color(red: 0.619, green: 0.325, blue: 1.0)
            ]), startPoint: .top, endPoint: .bottom)
            ).ignoresSafeArea(.all)
        
    }
}

struct HousemateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(first_name: "Bob", last_name: "Portis", phone_number: "9519012", email: "danielfg@gmail.com", birthday: "02/02/2000")
        HousemateProfileView(housemate: UserViewModel.mockUser())
            .environmentObject(AuthViewModel())
            .environmentObject(TaskViewModel())
           
    }
    
}
