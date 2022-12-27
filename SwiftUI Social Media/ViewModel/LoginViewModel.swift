//
//  LoginViewModel.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 27/12/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    
    //MARK: - User Details Properties
    @Published var emailID: String = ""
    @Published var password: String = ""
    
    //MARK: - View Properties
    @Published var createAccount: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    //MARK: UserDefaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_pic") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    //MARK: Functions
    func loginUser() {
        isLoading = true
        Task {
            do {
                //With the help of swift COncurrency Auth can be done with Single Line
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
                try await fetchUser()
            } catch {
                await setError(error)
            }
        }
    }
    
    //MARK: If user found then fetching user data from firestore
    func fetchUser() async throws {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        //MARK: UI Updating Must be Run on Main thread
        await MainActor.run(body: {
            //Setting UserDefaults data and changing App's Auth Status
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        })
    }
    
    
    func resetPassword() {
        Task {
            do {
                //With the help of swift COncurrency Auth can be done with Single Line
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            } catch {
                await setError(error)
            }
        }
    }
    
    //MARK: Displaying Error via Alert
    func setError(_ error : Error) async {
        //MARK: UI Must be updated on Main thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    
    
}
