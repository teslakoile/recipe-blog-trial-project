//
//  AddRecipeView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// allows users to Add, Edit, and Delete recipes
struct AddRecipeView: View {
    
    var recipe: Recipe?
    var isOwner: Bool
    
    @State private var recipeTitle: String = ""
    @State private var ingredients: [String] = []
    @State private var instructions: [String] = []
    @State private var newIngredient: String = ""
    @State private var newInstruction: String = ""

    // this variable enables owners to modify their own recipes only
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditing: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
            Form {
                Section(header: Text("Recipe Title")) {
                    TextField("Title", text: $recipeTitle)
                        .disabled(!isEditing || !isOwner) // Disable if not editing or not the owner
                }
                
                Section(header: Text("Ingredients")) {
                                    ForEach(0..<ingredients.count, id: \.self) { index in
                                        if isEditing && isOwner {
                                            TextField("Ingredient", text: $ingredients[index])
                                        } else {
                                            Text(ingredients[index])
                                        }
                                    }
                                    .onDelete(perform: deleteIngredient)
                                    .onMove(perform: moveIngredient)
                                    
                                    if isEditing && isOwner {
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
                                    ForEach(0..<instructions.count, id: \.self) { index in
                                        if isEditing && isOwner {
                                            TextField("Instruction", text: $instructions[index])
                                        } else {
                                            Text(instructions[index])
                                        }
                                    }
                                    .onDelete(perform: deleteInstruction)
                                    .onMove(perform: moveInstruction)
                                    
                                    if isEditing && isOwner {
                                        TextField("New Instruction", text: $newInstruction)
                                        Button("Add Instruction") {
                                            if !newInstruction.isEmpty {
                                                instructions.append(newInstruction)
                                                newInstruction = ""
                                            }
                                        }
                                        
                                    }
                                }
                
                if isEditing && isOwner {
                    Button("Save Recipe") {
                        saveRecipeToFirestore()
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    if isOwner && recipe != nil { // Show delete button only if the user is the owner and the recipe already exists
                            Button("Delete Recipe") {
                                self.showDeleteAlert = true
                            }
                            .foregroundColor(.red)
                            .alert(isPresented: $showDeleteAlert) {
                                // shows an alert when a user deletes a recipe
                                Alert(
                                    title: Text("Delete Recipe"),
                                    message: Text("Are you sure you want to delete this recipe?"),
                                    primaryButton: .destructive(Text("Yes")) {
                                        deleteRecipeFromFirestore()
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                    }
                }
            }
        
            .navigationBarTitle(navigationBarTitle, displayMode: .inline)
            .navigationBarItems(trailing: Button(isEditing ? "Done" : "Edit") {
                self.isEditing.toggle()
            }.disabled(!isOwner))

        .onAppear {
            if recipe == nil {
                isEditing = true
            } else {
                isEditing = false
            }
            if let existingRecipe = recipe {
                recipeTitle = existingRecipe.title
                ingredients = existingRecipe.ingredients
                instructions = existingRecipe.instructions
            }
        }
    }
    
    // saves the recipe to Firebase, edits if the recipe exists
    private func saveRecipeToFirestore() {
        // Get the current user's ID
        if let userId = Auth.auth().currentUser?.uid {
            // Reference to Firestore
            let db = Firestore.firestore()
            
            // Data to be saved or updated
            let recipeData: [String: Any] = [
                "title": recipeTitle,
                "ingredients": ingredients,
                "instructions": instructions,
                "userId": userId,
                "lastModified": FieldValue.serverTimestamp()
            ]
            
            if let existingRecipe = recipe {
                // Update existing recipe
                db.collection("recipes").document(existingRecipe.id).setData(recipeData) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            } else {
                // Create a new recipe document in Firestore
                var ref: DocumentReference? = nil
                ref = db.collection("recipes").addDocument(data: recipeData) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            }
        }
    }
    
    // deletes a recipe on Firebase
    private func deleteRecipeFromFirestore() {
            if let recipeId = recipe?.id {
                let db = Firestore.firestore()
                db.collection("recipes").document(recipeId).delete() { err in
                    if let err = err {
                        print("Error deleting document: \(err)")
                    } else {
                        print("Document successfully deleted")
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    
    // enables users to delete individual ingredients by sliding the row to the left
    private func deleteIngredient(at offsets: IndexSet) {
        if isEditing && isOwner {
            ingredients.remove(atOffsets: offsets)
        }
    }
    
    // enables users to delete individual instructions by sliding the row to the left
    private func deleteInstruction(at offsets: IndexSet) {
        if isEditing && isOwner {
            instructions.remove(atOffsets: offsets)
        }
    }
    
    // enables users to reorder individual ingredients by holding the row and moving it
    private func moveIngredient(from source: IndexSet, to destination: Int) {
        ingredients.move(fromOffsets: source, toOffset: destination)
    }
    
    // enables users to reorder individual instructions by holding the row and moving it
    private func moveInstruction(from source: IndexSet, to destination: Int) {
        instructions.move(fromOffsets: source, toOffset: destination)
    }
    
    // changes the title of the navbar depending on if the user is editing, adding, or viewing a recipe
    private var navigationBarTitle: String {
            if isEditing {
                return "Edit Recipe"
            } else if recipe == nil {
                return "Add Recipe"
            } else {
                return recipe?.title ?? "View Recipe"
            }
        }

}
