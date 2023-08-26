//
//  RecipeViewModel.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import Foundation
import Firebase

class RecipeViewModel: ObservableObject {
    @Published var recipes = [Recipe]()
    
    // Fetch, Add, Edit, Delete functions here
}
