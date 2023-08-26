//
//  LoginView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import Foundation
import SwiftUI
import Firebase

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToContent: Bool? = nil
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Button("Login") {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        // Navigate to ContentView
                        self.isLoggedIn = true
                        self.navigateToContent = true
                        
                    }
                    
                }
            }
            NavigationLink("", destination: ContentView(isLoggedIn: $isLoggedIn).navigationBarBackButtonHidden(true), tag: true, selection: $navigateToContent)
                .hidden()
        }
        .padding()
        .buttonStyle(.bordered)
    }
}

struct LoginPreview: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
