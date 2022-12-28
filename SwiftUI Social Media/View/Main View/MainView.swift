//
//  MainView.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 28/12/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        // MARK: TabView With Recent Post's And Office Tabs
        TabView {
            Text("Recent Post's")
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Post's")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile")
                }
        }
        // Changing Tab Lable Tint to Black
        .tint(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
