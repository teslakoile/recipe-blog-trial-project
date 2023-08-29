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
            Text("Sign Up 🍳")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 50)
            
            TextField("Full Name", text: $name)
                .frame(height: 50)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 15)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            
            TextField("Email", text: $email)
                .frame(height: 50)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 15)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            
            SecureField("Password", text: $password)
                .frame(height: 50)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 15)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            
            Button {
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
        label: {
            Text("Sign Up")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 40)
                .font(.system(size: 20, weight: .regular))
                .cornerRadius(15)
        }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Error"), message: Text(errorMessage ?? "Error"), dismissButton: .default(Text("OK")))
                        }
            NavigationLink("", destination: LoginView(isLoggedIn: $isLoggedIn).navigationBarBackButtonHidden(true), tag: true, selection: $navigateToLogin)
                .hidden()
        }
        .padding(.horizontal, 40)
    }
}


struct SignupPreview: PreviewProvider {
    static var previews: some View {
        SignUpView(isLoggedIn: .constant(false))
    }
}
