//
//  RecipeDetailView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import SwiftUI
import Firebase

struct RecipeDetailView: View {
    var recipe: Recipe
    var currentUserId: String // Pass the current user's ID here
    
    @State private var ingredients: [String] = []
    @State private var instructions: [String] = []
    @State private var showEditForm: Bool = false
    
    var body: some View {
        VStack {
            // Display recipe title, ingredients, and instructions
            Text(recipe.title)
            
            List(ingredients, id: \.self) { ingredient in
                Text(ingredient)
            }
            
            List(instructions, id: \.self) { instruction in
                Text(instruction)
            }
            
            // Conditionally display "Add Item" and "Save" buttons
            Text(currentUserId)
            Text(recipe.userId)
            if currentUserId == recipe.userId {
                Button("Edit Recipe") {
                    self.showEditForm = true
                }
//                .background(NavigationLink("", destination: AddRecipeView(recipe: recipe, isOwner: userId == recipe.userId), isActive: $showEditForm).hidden())
            }
        }
        .onAppear {
            self.ingredients = recipe.ingredients
            self.instructions = recipe.instructions
        }
    }
}
