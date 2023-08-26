//
//  AddRecipeView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddRecipeView: View {
    
    var recipe: Recipe?
    var isOwner: Bool
    
    
    @State private var recipeTitle: String = ""
    @State private var ingredients: [String] = []
    @State private var instructions: [String] = []
    @State private var newIngredient: String = ""
    @State private var newInstruction: String = ""

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Recipe Title")) {
                        TextField("Title", text: $recipeTitle)
                            .disabled(!isOwner) // Disable if read-only
                    }
                    
                    Section(header: Text("Ingredients")) {
                        ForEach(ingredients, id: \.self) { ingredient in
                            Text(ingredient)
                        }
                        if isOwner {
                            TextField("New Ingredient", text: $newIngredient)
                            Button("Add Ingredient") {
                                if !newIngredient.isEmpty {
                                    ingredients.append(newIngredient)
                                    newIngredient = ""
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Instructions")) {
                        ForEach(instructions, id: \.self) { instruction in
                            Text(instruction)
                        }
                        if isOwner {
                            TextField("New Instruction", text: $newInstruction)
                            Button("Add Instruction") {
                                if !newInstruction.isEmpty {
                                    instructions.append(newInstruction)
                                    newInstruction = ""
                                }
                            }
                        }
                    }
                    
                    if isOwner {
                        Section {
                            Button("Save Recipe") {
                                saveRecipeToFirestore()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
//                .navigationBarTitle("Add Recipe", displayMode: .inline)
            }
            .onAppear {
                if let existingRecipe = recipe {
                    recipeTitle = existingRecipe.title
                    ingredients = existingRecipe.ingredients
                    instructions = existingRecipe.instructions
                }
            }
        }
    
    private func saveRecipeToFirestore() {
        // Get the current user's ID
        if let userId = Auth.auth().currentUser?.uid {
            // Reference to Firestore
            let db = Firestore.firestore()
            
            // Create a new recipe document in Firestore
            var ref: DocumentReference? = nil
            ref = db.collection("recipes").addDocument(data: [
                "title": recipeTitle,
                "ingredients": ingredients,
                "instructions": instructions,
                "userId": userId
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
}
