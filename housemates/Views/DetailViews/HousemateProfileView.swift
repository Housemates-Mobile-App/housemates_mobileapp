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
        ZStack {
            VStack {
                VStack(spacing:10) {
                    
                    //image
                    let imageURL = URL(string: housemate.imageURLString ?? "")
                    
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .foregroundColor(.gray)
                    } placeholder: {
                        // Default user profile picture
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .foregroundColor(.gray)
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
                        .font(.system(size: 16))
                        .foregroundColor(housemate.is_home == nil ? Color(red: 0.827, green: 0.827, blue: 0.827) : (housemate.is_home! ? Color(red: 0.07, green: 0.77, blue: 0.52) : .red))
                    
                    HStack(spacing: 20) {
                        HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Call", iconStr: "call-phone", urlScheme:"tel")
                        HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Text", iconStr: "message-1", urlScheme:"sms")
                    }
                }.frame(width: 400, height: 300)
                    .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                    .padding(.top, 15)
                
                VStack(spacing: 20) {

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
                }
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.925, green: 0.863, blue: 1.0).opacity(1.00),
                Color(red: 0.619, green: 0.325, blue: 1.0).opacity(0.51)
            ]), startPoint: .top, endPoint: .bottom)
        ).ignoresSafeArea(.all)
        
    }
}

struct HousemateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        HousemateProfileView(housemate: UserViewModel.mockUser())
            .environmentObject(AuthViewModel())
            .environmentObject(TaskViewModel())
           
    }
    
}
