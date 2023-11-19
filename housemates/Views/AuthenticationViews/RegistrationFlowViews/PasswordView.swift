//
//  PasswordView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/18/23.
//

import SwiftUI

struct PasswordView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @Binding var password: String
    @Binding var confirmPassword: String
    
    var onContinue: () -> Void
    
    var isPasswordValid: Bool {
        !password.isEmpty && password.count > 5 && confirmPassword == password
    }

    var body: some View {
        VStack(alignment: .leading) {
            
            Text("What's your password?")
                .font(.custom("Lato-Bold", size: 25))
                .bold()
            
            InputView(text: $password,
              title: "Password",
              placeholder: "Enter your password",
              isSecureField: true)
            .padding(.bottom, 10)
            
            ZStack(alignment: .trailing) {
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Confirm your password",
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
            }.padding(.bottom, 25)

            HStack {
                Spacer()
                Button(action: onContinue) {
                    Text("DONE")
                        .font(.custom("Nunito-Bold", size: 25))
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width:130)
                        .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .cornerRadius(25)
                }.disabled(!isPasswordValid)
                    .opacity(isPasswordValid ? 1.0 : 0.5)
                Spacer()
            }            
            Spacer()
        }.navigationBarBackButtonHidden(true)
    }
    
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(password: .constant(""), confirmPassword: .constant(""), onContinue: {})
            .environmentObject(AuthViewModel())
    }
}
