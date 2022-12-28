//
//  LoginView.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 27/12/22.
//

import SwiftUI

struct LoginView: View {
    //MARK: - PROPERTIES
    @ObservedObject var loginVM = LoginViewModel()
    
    //MARK: - BODY
    var body: some View {
        VStack(spacing: 10) {
            Text("Lets Sign you in")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Welcome Back, \nYou have been missed")
                .font(.title3)
                .hAlign(.leading)
            
            VStack(spacing: 12) {
                TextField("Email", text: $loginVM.emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top, 25)
                    
                
                SecureField("Password", text: $loginVM.password)
                    .textContentType(.password)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top, 25)
                    
                
                Button {
                    loginVM.resetPassword()
                } label: {
                    Text("Reset Password?")
                }
                .font(.callout)
                .fontWeight(.medium)
                .tint(.black)
                .hAlign(.trailing)
                
                Button {
                    loginVM.loginUser()
                } label: {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top, 10)
            } //: VSTACK
            
            
            //MARK: - Register Button
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button("Register Now") {
                    loginVM.createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
            
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $loginVM.isLoading)
        })
        // MARK: Register View Via Sheets
        .fullScreenCover(isPresented: $loginVM.createAccount) {
            RegisterView()
        }
        //MARK: Displaying Alert
        .alert(loginVM.errorMessage, isPresented: $loginVM.showError, actions: {})
    }
}

// MARK: - PREVIEW
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
