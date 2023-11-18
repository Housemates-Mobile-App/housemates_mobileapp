//
//  EmailView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/18/23.
//

import SwiftUI

struct EmailView: View {
    @Binding var email: String
    var progress: Float
    var onContinue: () -> Void
    
    var isEmailValid: Bool {
        !email.isEmpty && email.contains("@")
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Progress Bar at the top
           ProgressBar(progress: progress)
               .frame(height: 10)
               .padding(.vertical)
            
            Text("What's your email?")
                .font(.custom("Lato-Bold", size: 28))
                .bold()
            
            InputView(text: $email,
              title: "Email",
              placeholder: "john_doe@gmail.com")
            .autocapitalization(.none)
            .padding(.bottom, 25)

            HStack {
                Spacer()
                Button(action: onContinue) {
                    Text("NEXT")
                        .font(.custom("Nunito-Bold", size: 24))
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width:130)
                        .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .cornerRadius(25)
                }.disabled(!isEmailValid)
                    .opacity(isEmailValid ? 1.0 : 0.5)
                Spacer()
            }


            
            Spacer()
        }.padding(.horizontal)
    }
}

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView(email: .constant(""), progress: 0.25, onContinue: {})
    }
}
