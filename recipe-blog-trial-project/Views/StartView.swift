//
//  Start.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import Foundation
import SwiftUI
import Firebase

struct StartView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Image("icon")
                NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn)) {
                    Text("Login")
                }
                .buttonStyle(.bordered)
                NavigationLink(destination: SignUpView(isLoggedIn: $isLoggedIn)) {
                    Text("Sign Up")
                }
                .buttonStyle(.bordered)
            }
        }
        .onAppear {
                    // Check if the user is already logged in
                    if Auth.auth().currentUser != nil {
                        isLoggedIn = true
                    }
                }
    }
}

struct StartPreview: PreviewProvider {
    static var previews: some View {
        StartView(isLoggedIn: .constant(false))
    }
}
