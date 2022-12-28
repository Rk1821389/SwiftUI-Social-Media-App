//
//  ContentView.swift
//  SwiftUI Social Media
//
//  Created by Manoj kumar on 27/12/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        //MARK: Redirecting User Based on log Status
        if logStatus {
            MainView()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
