//
//  ProfileView.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 28/12/22.
//

import SwiftUI


struct ProfileView: View {
    //MARK: - PROPERTIES
    @ObservedObject private var profileVM = ProfileViewModel()
    
    //MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack {
                if let profile = profileVM.myProfile {
                    ReusableProfileContent(user: profile)
                        .refreshable {
                            //MARK: Refresh User Data
                            self.profileVM.myProfile = nil
                            await profileVM.fetchUserData()
                        }
                } else {
                    ProgressView()
                }
            }
            .refreshable {
                //MARK: Refresh User Data
                profileVM.myProfile = nil
                await profileVM.fetchUserData()
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        //MARK: Two Action's
                        // 1. Logout
                        // 2. Delete Account
                        Button("Logout", action: profileVM.logOutUser)
                        Button("Delete Account", role: .destructive, action: profileVM.deleteAccount)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }

                }
            }
        }
        .overlay {
            LoadingView(show: $profileVM.showError)
        }
        .alert(profileVM.errorMessage, isPresented: $profileVM.showError) {
            
        }
        .task {
            //This Modieier is like onAppear
            //So fetching for the first time only
            if profileVM.myProfile != nil { return }
            //MARK: Initial Fetch
            await profileVM.fetchUserData()
        }
    }
}

//MARK: - PREVIEW
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
