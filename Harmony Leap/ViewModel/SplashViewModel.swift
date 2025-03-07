//
//  SplashViewModel.swift
//  Harmony Leap
//
//  
//

import Foundation

class SplashViewModel: ObservableObject {
    @Published var timer: Double = 0.0
    @Published var onboarding: Bool = false
    @Published var tabPage: Bool = false
    private var localTimer: Timer?
    
    func start() {
        localTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { time in
            
            if self.timer <= 0.9{
                self.timer += 0.1
                
            } else {
                self.localTimer?.invalidate()
                self.show()
            }
        }
    }
    
    private func show() {
        let userDefaults = UserDefaults()
        let showedOnboarding = userDefaults.bool(forKey: StaticValues.show.onboarding.rawValue)
        showedOnboarding ? (tabPage = true) : (onboarding = true)
    }
}
