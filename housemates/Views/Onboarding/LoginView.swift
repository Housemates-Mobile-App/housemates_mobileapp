//
//  LoginView.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 10/31/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack{
            // housemates logo
            Image("House")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            Text("HouseMates")
            // text for displaying housemates
            
            // enable form
            VStack(spacing: 24) {
                //          email entry
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                .autocapitalization(.none)
                
                //          password entry
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Please enter your password",
                            isSecureField: true)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            //          login button itself
            
            Button {
                print("log user in")
            } label: {
                HStack {
                    Text("SIGN IN")
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
            
            NavigationLink{
                RegistrationView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                Text("New User?")
                Text("Please Sign Up!")
                    .fontWeight(.bold)
            }
            .font(.system(size: 14))
            
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
