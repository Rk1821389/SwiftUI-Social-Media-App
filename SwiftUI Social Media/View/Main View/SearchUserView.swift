//
//  SearchUserView.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 02/01/23.
//

import SwiftUI
import FirebaseFirestore

struct SearchUserView: View {
    //MARK: View Properties
    @State private var fetchedUser: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        List{
            ForEach(fetchedUser) { user in
                NavigationLink {
                    ReusableProfileContent(user: user)
                } label: {
                    Text(user.username)
                        .font(.callout)
                        .hAlign(.leading)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search")
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            /// - Fetch User from Firebase
            Task { await searchUser() }
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty {
                fetchedUser = []
            }
        })
        
    }
    
    func searchUser() async {
        do {
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: searchText)
                .whereField("username", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            ///- UI Must be Updated on Main Thread
            await MainActor.run(body: {
                fetchedUser = users
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
