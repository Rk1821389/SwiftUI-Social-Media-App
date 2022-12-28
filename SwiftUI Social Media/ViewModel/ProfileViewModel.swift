//
//  ProfileViewModel.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 28/12/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    
    //MARK: My Profile Data
    @Published var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    //MARK: View Properties
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
    
    //MARK: - Fetching User Data
    func fetchUserData() async {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        guard let user = try? await  Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else { return }
        await MainActor.run(body: {
            myProfile = user
        })
    }
    
    //MARK: Logging User Out
    func logOutUser() {
        try? Auth.auth().signOut()
        logStatus = false
    }
    
    //MARK: Deleting User Entire Account
    func deleteAccount() {
        isLoading = true
        Task {
            do {
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                //Step 1. First Deleting Profile Image From Storage
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await reference.delete()
                //Step 2: Deleting Firestore User Document
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                //Final Step: Deleting Auth Account and setting Log Status to False
                try await Auth.auth().currentUser?.delete()
                logStatus = false
            } catch {
             await setError(error)
            }
        }
    }
    
    //MARK: Setting Error
    func setError(_ error: Error) async {
        //MARK: UI Must be run on Main Thread
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
}


