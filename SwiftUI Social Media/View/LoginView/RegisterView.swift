//
//  RegisterView.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 27/12/22.
//

import SwiftUI

struct RegisterView: View {
    
    @ObservedObject var registerVM = RegisterViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    //MARK: - BODY
    var body: some View {
        VStack(spacing: 10) {
            Text("Lets Register \nAccount")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Hello user, you have a wonderful journey")
                .font(.title3)
                .hAlign(.leading)
            
            //MARK: For Smaller Size Optimization
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                HelperView()
            }
            
            
            //MARK: - Register Button
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Button("Login Now") {
                    dismiss()
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
            LoadingView(show: $registerVM.isLoading)
        })
        .photosPicker(isPresented: $registerVM.showImagePicker, selection: $registerVM.photoItem)
        .onChange(of: registerVM.photoItem) { newValue in
            //MARK: Extracting UIImage from PhotoItem
            if let newValue {
                Task {
                    do {
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else {
                            return
                        }
                        //MARK: UI Must be updated on Main thread
                        await MainActor.run(body: {
                            registerVM.userProfilePicData = imageData
                        })
                        
                    } catch {
                        //Throw Error
                    }
                }
            }
        }
        //MARK: Displaying Alert
        .alert(registerVM.errorMessage, isPresented: $registerVM.showError, actions: {})
    }
    
    @ViewBuilder
    func HelperView() -> some View {
        VStack(spacing: 12) {
            ZStack {
                if let picData = registerVM.userProfilePicData, let image = UIImage(data: picData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill
                        )
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                registerVM.showImagePicker.toggle()
            }
            .padding(.top, 25)
            
            TextField("Username", text: $registerVM.username)
                .textContentType(.username)
                .border(1, .gray.opacity(0.5))
            
            
            TextField("Email", text: $registerVM.emailID)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            SecureField("Password", text: $registerVM.password)
                .textContentType(.password)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            TextField("About You", text: $registerVM.userBio, axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.none)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            TextField("Bio Link (Optional)", text: $registerVM.userBioLink)
                .textContentType(.URL)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            Button(action: registerVM.registerUser) {
                Text("Sign up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.black)
            }
            .disableWithOpacity(registerVM.username == "" || registerVM.userBio == "" || registerVM.emailID == "" || registerVM.password == "" || registerVM.userProfilePicData == nil)
            .padding(.top, 10)
            
            
        } //: VSTACK
    }
}

//MARK: - PREVIEW
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
