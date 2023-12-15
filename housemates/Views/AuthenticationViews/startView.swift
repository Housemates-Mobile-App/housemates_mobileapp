//
//  startView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/16/23.
//

import SwiftUI

struct startView: View {
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 0) {
                    Image("LogoLoading")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .padding(.top, 100)
                    Text("Housemates")
                        .font(.custom("Nunito-Bold", size: 40))
                        .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                    Text("Todo, together.")
                        .font(.custom("Nunito", size: 16))
                        .foregroundColor(Color(red: 0.415, green: 0.412, blue: 0.412))
                }
                
                Spacer()
                VStack(spacing: 10) {
                    NavigationLink(destination: RegistrationView()) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.439, green: 0.298, blue: 1.0))
                            .frame(width:357, height:61)
                            .overlay(
                                Text("Get Started")
                                    .font(.custom("Nunito-Bold", size: 20))
                                    .foregroundColor(.white)
                            )
                    }
                    NavigationLink(destination: LoginView()) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 0.588, green: 0.584, blue: 0.584))
                            .frame(width:357, height:61)
                            .overlay(
                                Text("Login")
                                    .font(.custom("Nunito-Bold", size: 20))
                                    .bold()
                                    .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                            )
                    }
                }.padding()
            }
        }
    }
}

//#Preview {
//    startView()
//}

struct startView_Previews: PreviewProvider {
    static var previews: some View {
        startView()
           
    }
    
}
