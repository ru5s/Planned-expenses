//
//  Harmony_LeapApp.swift
//  Harmony Leap
//
//  Created by Den on 04/04/24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      UITabBar.appearance().isTranslucent = true
      UITabBar.appearance().backgroundColor = UIColor.superWhite
      UITabBar.appearance().barTintColor = UIColor.superWhite
      UITabBar.appearance().unselectedItemTintColor = UIColor.passiveTabGreen
      
      return true
  }
}

@main
struct Harmony_LeapApp: App {
    let persistenceController = CoreDataService.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.light)
        }
    }
}
