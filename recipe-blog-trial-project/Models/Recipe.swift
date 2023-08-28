//
//  Recipe.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import Foundation
import Firebase

struct Recipe: Identifiable {
    var id: String
    var title: String
    var ingredients: [String]
    var instructions: [String]
    var userId: String
    var lastModified: Timestamp?
}
