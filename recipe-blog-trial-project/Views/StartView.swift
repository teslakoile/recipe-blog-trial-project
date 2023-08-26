//
//  Start.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import Foundation
import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("icon")
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                }
                .buttonStyle(.bordered)
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct StartPreview: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
