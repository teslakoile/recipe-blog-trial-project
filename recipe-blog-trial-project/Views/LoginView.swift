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
    @State private var errorMessage: String? = nil
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            Text("Login 🍳")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 50)
            
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
            
            // Uses Firebase to log the user in using email and password
            Button {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        errorMessage = e.localizedDescription
                        showingAlert = true
                    } else {
                        // Navigate to ContentView
                        self.isLoggedIn = true
                        self.navigateToContent = true
                        
                    }
                    
                }
            }
        label: {
            Text("Login")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 40)
                .font(.system(size: 20, weight: .regular))
                .cornerRadius(15)
        }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            // Shows an alert message when the user's inputs are not formatted well
            .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Error"), message: Text(errorMessage ?? "Error"), dismissButton: .default(Text("OK")))
                        }
            NavigationLink("", destination: ContentView(isLoggedIn: $isLoggedIn).navigationBarBackButtonHidden(true), tag: true, selection: $navigateToContent)
                .hidden()
        }
        .padding(.horizontal, 40)
    }
}

struct LoginPreview: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
