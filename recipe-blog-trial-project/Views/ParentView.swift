//
//  ParentView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import SwiftUI

struct ParentView: View {
    @State private var isLoggedIn: Bool = false

    var body: some View {
            Group {
                if isLoggedIn {
                    ContentView(isLoggedIn: $isLoggedIn)
                } else {
                    NavigationView {
                        StartView(isLoggedIn: $isLoggedIn)
                    }
                }
            }
        }
}
