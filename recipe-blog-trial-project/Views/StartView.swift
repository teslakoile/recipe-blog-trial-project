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
                Text("🍳")
                    .font(.system(size: 140))
                    .padding(.bottom, 20)
                
                Text("Welcome to CookingCorner!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                
                
                NavigationLink(destination: SignUpView(isLoggedIn: $isLoggedIn)) {
                    Text("Sign Up")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 40)
                        .font(.system(size: 20, weight: .regular))
                        .cornerRadius(15)
                        .foregroundColor(.orange)
                        
                }
                .padding(.vertical, 5)
                .buttonStyle(.bordered)
                
                
                NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn)) {
                    Text("Login")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 40)
                        .font(.system(size: 20, weight: .regular))
                        .cornerRadius(15)
                        
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
    
                
            }
            .padding(.horizontal, 40)
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
