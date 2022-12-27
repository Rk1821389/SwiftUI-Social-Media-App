//
//  RegisterViewModel.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 27/12/22.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class RegisterViewModel: ObservableObject {
    
    //MARK: - User Properties
    @Published var emailID: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var userBio: String = ""
    @Published var userBioLink: String = ""
    @Published var userProfilePicData: Data?
    
    //MARK: View Properties
    @Published var showImagePicker: Bool = false
    @Published var photoItem: PhotosPickerItem?
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    //MARK: UserDefaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_pic") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    //MARK: Functions
    
    func registerUser() {
        isLoading = true
        Task {
            do  {
                //Step 1: Creating Firebase Account
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                // Step 2: Uploading Profile Photo Into firbase storage
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                guard let imageData = userProfilePicData else { return }
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                //Step 3: Downloading Photo URL
                let downloadURL = try await storageRef.downloadURL()
                //Step 4: Creating a User Firestore Object
                let user = User(username: username, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
                //Step 5: Saving User Doc into Firestore Database
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
                    if error == nil {
                        //MARK: Print Saved Successfully
                        print("Saved Successfully")
                        self.userNameStored = self.username
                        self.userUID = userUID
                        self.profileURL = downloadURL
                        self.logStatus = true
                    }
                })
            } catch {
                try await Auth.auth().currentUser?.delete()
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
