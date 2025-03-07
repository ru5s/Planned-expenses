//
//  OnboardingView.swift
//  Harmony Leap
//
//  
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var model = OnboardingVIewModel()
    @State var activeTab: Int = 0

    var body: some View {
        slides
            .ignoresSafeArea()
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var slides: some View {
        TabView(selection: $activeTab,
                content:  {
            ForEach(Array(model.slides.enumerated()), id: \.element) { index, slide in
                OnboardingCell(item: slide, itemCount: model.slides.count, activeDot: $activeTab)
                    .tag(index)
            }
            .ignoresSafeArea()
        })
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .navigationViewStyle(StackNavigationViewStyle())
        .animation(.easeInOut)
        .background(Color.superBlack)
    }
}

#Preview {
    OnboardingView()
}
