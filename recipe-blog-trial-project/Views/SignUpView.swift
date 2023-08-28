//
//  SignUpView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @Binding var isLoggedIn: Bool
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToLogin: Bool? = nil
    @State private var errorMessage: String? = nil
    @State private var showingAlert = false
    
    var body: some View {
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
                        errorMessage = e.localizedDescription
                        showingAlert = true
                    } else {
                        // Update user's profile to save the name
                        if let user = authResult?.user {
                                    let userId = user.uid
                                    
                                    // Save additional user info in Firestore
                                    let db = Firestore.firestore()
                                    db.collection("users").document(userId).setData([
                                        "name": name,
                                        "email": email
                                    ]) { err in
                                        if let err = err {
                                            print("Error writing document: \(err)")
                                        } else {
                                            print("Document successfully written!")
                                        }
                                    }
                                }
                        // Navigate to LoginView
                        self.isLoggedIn = true
                        self.navigateToLogin = true
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Error"), message: Text(errorMessage ?? "Error"), dismissButton: .default(Text("OK")))
                        }
            NavigationLink("", destination: LoginView(isLoggedIn: $isLoggedIn).navigationBarBackButtonHidden(true), tag: true, selection: $navigateToLogin)
                .hidden()
        }
        .padding()
    }
}


struct SignupPreview: PreviewProvider {
    static var previews: some View {
        SignUpView(isLoggedIn: .constant(false))
    }
}
