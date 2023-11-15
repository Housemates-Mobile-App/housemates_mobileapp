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
        VStack {
            //image
            let imageURL = URL(string: housemate.imageURLString ?? "")
            
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 111, height: 111)
                    .clipShape(Circle())
            } placeholder: {
                // Default user profile picture
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 111, height: 111)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
            }
            
            Text("\(housemate.first_name) \(housemate.last_name)")
                .font(.system(size: 26))
                .bold()
                .foregroundColor(.black)
            
            HStack(spacing: 20) {
                HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Call", iconStr: "phone", urlScheme:"tel")
                HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Text", iconStr: "message", urlScheme:"sms")
            }
        }
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
