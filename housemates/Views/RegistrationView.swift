//
//  RegistrationView.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 10/31/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fname = ""
    @State private var lname = ""
    @State private var phone = ""
    @State private var dob = ""
    @State private var confirmPassword = ""
    @State private var password = ""
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            // housemates logo
            Image("House")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            Text("HouseMates")
            
            VStack(spacing: 24) {
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                .autocapitalization(.none)
                
                InputView(text: $fname,
                          title: "First Name",
                          placeholder: "John")
                
                InputView(text: $lname,
                          title: "Last Name",
                          placeholder: "Doe")
                
                InputView(text: $phone,
                          title: "Phone Number",
                          placeholder: "888-888-8888")
                
                InputView(text: $dob,
                          title: "Date of Birth",
                          placeholder: "01-01-2000")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Please enter your password",
                            isSecureField: true)
                
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Please confirm your password",
                            isSecureField: true)
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                print("sign user up")
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Already have an account?")
                Text("Please Sign In!")
                    .fontWeight(.bold)
            }
            .font(.system(size: 14))
            
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
