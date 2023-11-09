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
    @EnvironmentObject var authViewModel : AuthViewModel

   
    var body: some View {
        VStack{
            // MARK: Housemates Logo
            Image("housematesLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
            
            // MARK: Registration Form
            VStack(spacing: 10) {
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
                
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Please confirm your password",
                                isSecureField: true)
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // MARK: Registration Button
            Button {
                Task {
                    try await authViewModel.createUser(withEmail: email, password: password, first_name: fname, last_name: lname, phone_number: phone, birthday: dob)
                }
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
            .disabled(!formisValid)
            .opacity(formisValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Please Sign In!")
                        .fontWeight(.bold)
                }
                
            }
            .font(.system(size: 14))
            
        }
    }
}

// MARK: Authentication Protocol
extension RegistrationView: AuthenticationFormProtocol {
    var formisValid: Bool {
        return (!email.isEmpty
                && email.contains("@")
                && !password.isEmpty
                && password.count > 5
                && confirmPassword == password
                && !fname.isEmpty
                && !lname.isEmpty
                && !phone.isEmpty
                && !dob.isEmpty
                
        )
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
