//
//  DateOfBirthView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/18/23.
//

import SwiftUI

struct DateOfBirthView: View {
    @Binding var dob: String
    var progress: Float
    var onContinue: () -> Void
    
    var isDOBValid: Bool {
        !dob.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Progress Bar at the top
           ProgressBar(progress: progress)
               .frame(height: 10)
               .padding(.vertical)
            
            Text("What's your date of birth?")
                .font(.custom("Lato-Bold", size: 28))
                .bold()
            
            InputView(text: $dob,
              title: "Date of Birth",
              placeholder: "01-01-2000")
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
                }.disabled(!isDOBValid)
                    .opacity(isDOBValid ? 1.0 : 0.5)
                Spacer()
            }


            
            Spacer()
        }.padding(.horizontal)
    }
}

struct DateOfBirthView_Previews: PreviewProvider {
    static var previews: some View {
        DateOfBirthView(dob: .constant(""), progress: 0.25, onContinue: {})
    }
}

