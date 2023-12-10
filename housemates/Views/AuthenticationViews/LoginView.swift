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
            VStack {
                // MARK: Housemates Logo
                Image("LogoLoading")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 221, height: 221)
                    .padding(.bottom, 20)
                
                VStack(spacing:15) {
                    // MARK: Login Form
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "Email")
                    .autocapitalization(.none)
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Password",
                              isSecureField: true)
                }
                // MARK: Sign in Button
                Button {
                    Task {
                        try await authViewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("LOGIN")
                            .font(.custom("Nunito-Bold", size: 24))
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(red: 0.439, green: 0.298, blue: 1.0))
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
                .padding(.bottom, getSafeAreaInsets().bottom)
            }
            .padding(.bottom, getBottomPadding())
            .padding(.horizontal)
            .ignoresSafeArea(edges: .bottom)

        }
    }
    
    private func getSafeAreaInsets() -> UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
    }

    // Determine if we need additional bottom padding
    private func getBottomPadding() -> CGFloat {
        let insets = getSafeAreaInsets()
        return max(0, 50 - insets.bottom) // Assumes 50 is the desired minimum bottom padding
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

