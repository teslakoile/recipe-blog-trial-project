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
                            RecipeRow(recipe: recipe, isOwner: userId == recipe.userId)
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
//        if let userId = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            db.collection("recipes")
                .order(by: "lastModified", descending: true)
                .addSnapshotListener { querySnapshot, error in
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
                    let lastModified = data["lastModified"] as? Timestamp
                    return Recipe(
                        id: queryDocumentSnapshot.documentID,
                        title: title,
                        ingredients: ingredients,
                        instructions: instructions,
                        userId: creatorId,
                        lastModified: lastModified
                    )
                }
            }
//        }
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
    var isOwner: Bool
    @State private var userName: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(recipe.title)
                .font(.system(size: 22, weight: .bold))
                .padding(.bottom, 5)
            
            
            Text("\(userName)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isOwner ? Color.orange : Color.gray)
                .padding(.bottom, 10)
            
            if let lastModified = recipe.lastModified?.dateValue() {
                let formatter = DateFormatter()
                Text("\(recipe.formattedLastModified)")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.gray)
            }
//
//            Text(recipe.ingredients.joined(separator: ", "))
//                .lineLimit(1)
//                .truncationMode(.tail)
            
        }
        .onAppear {
                    fetchUserName(userId: recipe.userId)
                }
        .padding()
    }
    
    private func fetchUserName(userId: String) {
            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { document, error in
                if let document = document, document.exists {
                    if let data = document.data() {
                        self.userName = data["name"] as? String ?? "Unknown"
                    }
                }
            }
        }
}


extension Recipe {
    var formattedLastModified: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        if let lastModified = self.lastModified?.dateValue() {
            return formatter.string(from: lastModified)
        } else {
            return "Unknown"
        }
    }
}


struct ContentPreview: PreviewProvider {
    static var previews: some View {
        ContentView(isLoggedIn: .constant(true))
    }
}
