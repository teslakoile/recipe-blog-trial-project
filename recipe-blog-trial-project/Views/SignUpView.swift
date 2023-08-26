//
//  SignUpView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                Button("Sign Up") {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let e = error {
                            print(e.localizedDescription)
                        } else {
                            // Update user's profile to save the name
                            if let user = Auth.auth().currentUser {
                                let changeRequest = user.createProfileChangeRequest()
                                changeRequest.displayName = name
                                changeRequest.commitChanges { error in
                                    if let e = error {
                                        print(e.localizedDescription)
                                    }
                                }
                            }
                            // Navigate to LoginView
                            self.navigateToLogin = true
                        }
                    }
                }
                NavigationLink("", destination: LoginView())
            }
            .padding()
        }
    }
}


struct SignupPreview: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
