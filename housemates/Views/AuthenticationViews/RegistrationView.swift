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
    @State private var currentStep = 0
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel : AuthViewModel

    func signUp() {
        DispatchQueue.main.async {
            Task {
                try await authViewModel.createUser(
                    withEmail: email,
                    password: password,
                    first_name: fname,
                    last_name: lname,
                    phone_number: phone,
                    birthday: dob
                )
                // handle post sign up logic? mayb for later
            }
        }
    }
    
    func backButton() -> some View {
        Button(action: {
            if currentStep > 0 {
                currentStep -= 1
            }
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
        }
    }
   
    var body: some View {
        NavigationView {
            VStack{
                if currentStep > 0 {
                    backButton()
                }
                if currentStep == 0 {
                    FirstNameView(fname: $fname, progress: calculateProgress()) {
                        currentStep += 1
                    }
                }
                else if currentStep == 1 {
                    LastNameView(lname: $lname, progress: calculateProgress()) {
                        currentStep += 1
                    }
                }
                else if currentStep == 2 {
                    DateOfBirthView(dob: $dob, progress: calculateProgress()) {
                        currentStep += 1
                    }
                }
                else if currentStep == 3 {
                    PhoneNumberView(phoneNumber: $phone, progress: calculateProgress()) {
                        currentStep += 1
                    }
                }
                else if currentStep == 4 {
                    EmailView(email: $email, progress: calculateProgress()) {
                        currentStep += 1
                    }
                }
                else if currentStep == 5 {
                    PasswordView(password: $password, confirmPassword: $confirmPassword, progress: calculateProgress()) {
                        if formisValid {
                            self.signUp()
                        }
                    }
                }
                
            }
        }
    }
    
    func calculateProgress() -> Float {
           return Float(currentStep) / Float(6)
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
