//
//  PhoneNumberView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/18/23.
//

import SwiftUI

struct PhoneNumberView: View {
    @Binding var phoneNumber: String
    var progress: Float
    var onContinue: () -> Void
    
    var isPhoneNumberValid: Bool {
        !phoneNumber.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Progress Bar at the top
           ProgressBar(progress: progress)
               .frame(height: 10)
               .padding(.vertical)
            
            Text("What's your phone number?")
                .font(.custom("Lato-Bold", size: 28))
                .bold()
            
            InputView(text: $phoneNumber,
              title: "Phone Number",
              placeholder: "1234567890")
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
                }.disabled(!isPhoneNumberValid)
                    .opacity(isPhoneNumberValid ? 1.0 : 0.5)
                Spacer()
            }


            
            Spacer()
        }.padding(.horizontal)
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView(phoneNumber: .constant(""), progress: 0.25, onContinue: {})
    }
}
