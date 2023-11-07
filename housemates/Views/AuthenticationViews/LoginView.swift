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
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack{
                // MARK: Housemates Logo
                Image("House")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                
                // MARK: Housemates Title
                Text("HouseMates")
                
                // MARK: Login Form
                VStack(spacing: 10) {
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Please enter your password",
                              isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // MARK: Sign in Button
                Button {
                    Task {
                        try await authViewModel.signIn(withEmail: email, password: password)
                    }
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
                .disabled(!formisValid)
                .opacity(formisValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                // MARK: Navigation Link to Registration View
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("New User?")
                        Text("Please Sign Up!")
                            .fontWeight(.bold)
                    }
                }
                .font(.system(size: 14))
                
                
            }
        }
    }
}

// MARK: Authentication Protocol
extension LoginView: AuthenticationFormProtocol {
    var formisValid: Bool {
        return (!email.isEmpty
                && email.contains("@")
                && !password.isEmpty
                && password.count > 0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
