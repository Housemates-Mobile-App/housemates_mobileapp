//
//  EmailView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 12/9/23.
//

import SwiftUI

struct UsernameView: View {
    @Binding var username: String
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var errorMessage: String = ""
    
    var onContinue: () -> Void
    
    var isUsernameValid: Bool {
        errorMessage.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading) {
            
            Text("What's your username?")
                .font(.custom("Lato-Bold", size: 25))
                .bold()
            
            InputView(text: $username,
              title: "Username",
              placeholder: "johndoe123")
            .autocapitalization(.none)
            .onChange(of: username, perform: { _ in
                            validateUsername()
                        })
            .onAppear(perform: {
                validateUsername()
            })
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.custom("Lato", size: 14))
                    .padding(.bottom, 25)
            } else {
                Text("imaginary text")
                    .foregroundColor(.clear)
                    .font(.custom("Lato", size: 14))
                    .padding(.bottom, 25)
            }

            HStack {
                Spacer()
                Button(action: onContinue) {
                    Text("NEXT")
                        .font(.custom("Nunito-Bold", size: 25))
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width:130)
                        .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .cornerRadius(25)
                }.disabled(!isUsernameValid)
                    .opacity(isUsernameValid ? 1.0 : 0.5)
                Spacer()
            }


            
            Spacer()
        }.navigationBarBackButtonHidden(true)
    }
    
    func validateUsername() {
        if username.isEmpty {
            errorMessage = "Username cannot be empty"
        } else if !userViewModel.usernameIsAvailable(username: username) {
            errorMessage = "Username is already taken"
        } else {
            errorMessage = ""
        }
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView(username: .constant(""), onContinue: {})
            .environmentObject(UserViewModel())
    }
}
