//
//  Post.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 28/12/22.
//

import SwiftUI
import FirebaseFirestoreSwift

//MARK: Post Model
struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var imageURL: URL?
    var imageReferenceID: String = ""
    var publishedDate: Date = Date()
    var linkedIDs: [String] = []
    var likedIDs: [String] = []
    var dislikedIDs: [String] = []
    //MARK: Basic User Info
    var username: String
    var userUID: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case imageURL
        case imageReferenceID
        case publishedDate
        case linkedIDs
        case likedIDs
        case dislikedIDs
        case username
        case userUID
        case userProfileURL
    }
    
}
