//
//  LoginView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Button("Login") {
                // Firebase login logic here
            }
            .buttonStyle(.bordered)
        }
    }
}

struct LoginPreview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
