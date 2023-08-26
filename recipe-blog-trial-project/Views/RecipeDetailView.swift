//
//  RecipeDetailView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import Foundation
import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe // Assume Recipe is your data model
    
    var body: some View {
        VStack {
            Text(recipe.title)
            ForEach(recipe.instructions, id: \.self) { step in
                Text(step)
            }
//            if recipe.userId == /* Current User ID */ {
//                Button("Edit") {
//                    // Edit logic here
//                }
//                Button("Delete") {
//                    // Delete logic here
//                }
//            }
        }
    }
}

