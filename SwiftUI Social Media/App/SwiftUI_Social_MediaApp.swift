//
//  SwiftUI_Social_MediaApp.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 27/12/22.
//

import SwiftUI
import Firebase

@main
struct SwiftUI_Social_MediaApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
