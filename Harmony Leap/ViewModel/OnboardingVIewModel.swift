//
//  OnboardingVIewModel.swift
//  Harmony Leap
//
//  
//

import Foundation

class OnboardingVIewModel: ObservableObject {
    @Published var slides: [OnboardingModel] = [
        .init(image: StaticValues.onboarding.slide0.rawValue, title: "Control your \n credit", buttonTitle: "Next"),
        .init(image: StaticValues.onboarding.slide1.rawValue, title: "Convenient \n tracking", buttonTitle: "Next"),
    ]
}
