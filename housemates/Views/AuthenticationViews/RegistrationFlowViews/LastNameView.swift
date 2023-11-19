//
//  LastNameView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/18/23.
//

import SwiftUI

struct LastNameView: View {
    @Binding var lname: String
    var onContinue: () -> Void
    
    var isLastNameValid: Bool {
        !lname.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading) {
            
            Text("What's your last name?")
                .font(.custom("Lato-Bold", size: 25))
                .bold()
            
            InputView(text: $lname,
              title: "Last Name",
              placeholder: "Doe")
            .padding(.bottom, 25)

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
                }.disabled(!isLastNameValid)
                    .opacity(isLastNameValid ? 1.0 : 0.5)
                Spacer()
            }
            Spacer()
        }.navigationBarBackButtonHidden(true)
    }
}

struct LastNameView_Previews: PreviewProvider {
    static var previews: some View {
        LastNameView(lname: .constant(""), onContinue: {})
    }
}

