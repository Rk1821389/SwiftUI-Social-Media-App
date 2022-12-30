//
//  ReusablePostView.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 31/12/22.
//

import SwiftUI
import Firebase

struct ReusablePostView: View {
    @Binding var posts: [Post]
    ///VIew Properties
    @State var isFetching: Bool = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                if isFetching {
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    if posts.isEmpty {
                        /// No  Post found on firestore
                        Text("No Post's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    } else {
                        //Display Post's
                        Posts()
                    }
                }
            }
            .padding(15)
        }
        .refreshable {
            /// - Scroll to Refresh
            isFetching = true
            posts = []
            await fetchPosts()
        }
        .task {
            /// - Fetching For the One time
            guard posts.isEmpty else { return }
            await fetchPosts()
        }
    }
    
    //Displaying Fetched Post's
    @ViewBuilder
    func Posts() -> some View {
        ForEach(posts) { post in
            PostCardView(post: post) { updatedPost in
                ///Updating Post in the Array
                if let index = posts.firstIndex(where: { post in
                    post.id == updatedPost.id
                }){
                    posts[index].likedIDs = updatedPost.likedIDs
                    posts[index].dislikedIDs = updatedPost.dislikedIDs
                }
            } onDelete: {
                //Removing POst From the Array
                withAnimation(.easeInOut(duration: 0.25)) {
                    posts.removeAll { post.id == $0.id }
                }
            }

            Divider()
                .padding(.horizontal, -15)
        }
    }
    
    func fetchPosts() async {
        do {
            var query: Query!
            query = Firestore.firestore().collection("Posts")
                .order(by: "publishedDate", descending: true)
                .limit(to: 20)
            let docs = try await query.getDocuments()
            let fetchPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            await MainActor.run(body: {
                posts = fetchPosts
                isFetching = false
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

//struct ReusablePostView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReusablePostView()
//    }
//}
