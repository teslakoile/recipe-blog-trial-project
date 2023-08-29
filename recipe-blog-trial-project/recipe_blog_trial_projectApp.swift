//
//  recipe_blog_trial_projectApp.swift
//  recipe-blog-trial-project
//
//  Created by Kyle Naranjo on 8/26/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
      // Configure Firebase for the App
      FirebaseApp.configure()
      let db = Firestore.firestore()
      print(db)

    return true
  }
}

@main
struct recipe_blog_trial_projectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ParentView()
        }
    }
}
