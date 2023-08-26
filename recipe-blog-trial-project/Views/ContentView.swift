//
//  ContentView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                // Populate this list with recipes from Firebase
            }
            .navigationBarItems(trailing: Button("Add") {
                // Navigate to add new recipe form
            })
        }
    }
}
