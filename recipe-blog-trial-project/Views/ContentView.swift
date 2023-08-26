//
//  ContentView.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import Foundation
import SwiftUI
import Firebase


struct ContentView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var recipes: [Recipe] = []
    @State private var showAddRecipeView: Bool = false
    @State private var showLogoutAlert: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipes, id: \.id) { recipe in
                    if let userId = Auth.auth().currentUser?.uid {
                        NavigationLink(destination: AddRecipeView(recipe: recipe, isOwner: userId == recipe.userId)) {
                            RecipeRow(recipe: recipe)
                        }
                    }
                    
                }
            }
            .navigationBarTitle("Recipes")
            .navigationBarItems(
                            leading: Button("Logout") {
                                self.showLogoutAlert = true
                            }
                            .alert(isPresented: $showLogoutAlert) {
                                Alert(
                                    title: Text("Logout"),
                                    message: Text("Are you sure you want to logout?"),
                                    primaryButton: .destructive(Text("Yes")) {
                                        logout()
                                    },
                                    secondaryButton: .cancel()
                                )
                            },
                            trailing: Button("Add") {
                                self.showAddRecipeView = true
                            }
                        )
            .background(NavigationLink("", destination: AddRecipeView(recipe: nil, isOwner: true), isActive: $showAddRecipeView).hidden())
            .onAppear {
                loadUserData()
                loadRecipes()
            }
        }
    }
        
    private func loadUserData() {
        // Get the current user's ID
        if let userId = Auth.auth().currentUser?.uid {
            // Reference to Firestore
            let db = Firestore.firestore()
            
            // Fetch user data from Firestore
            db.collection("users").document(userId).getDocument { document, error in
                if let document = document, document.exists {
                    // Parse and update the user data
                    if let data = document.data() {
                        self.name = data["name"] as? String ?? ""
                        self.email = data["email"] as? String ?? ""
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    private func loadRecipes() {
        if let userId = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            db.collection("recipes").addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                recipes = documents.map { queryDocumentSnapshot -> Recipe in
                    let data = queryDocumentSnapshot.data()
                    let title = data["title"] as? String ?? ""
                    let ingredients = data["ingredients"] as? [String] ?? []
                    let instructions = data["instructions"] as? [String] ?? []
                    let creatorId = data["userId"] as? String ?? ""
                    return Recipe(
                        id: queryDocumentSnapshot.documentID,
                        title: title,
                        ingredients: ingredients,
                        instructions: instructions,
                        userId: creatorId
                    )
                }
            }
        }
    }
    
    private func logout() {
            do {
                try Auth.auth().signOut()
                isLoggedIn = false
                // Navigate to login or start screen
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
}

struct RecipeRow: View {
    var recipe: Recipe
    
    var body: some View {
        Text(recipe.title)
        Text(recipe.userId)
    }
}



struct ContentPreview: PreviewProvider {
    static var previews: some View {
        ContentView(isLoggedIn: .constant(true))
    }
}
