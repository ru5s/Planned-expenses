//
//  SplashView.swift
//  Harmony Leap
//
//  
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var model = SplashViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                links
                logoPlusProgress
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.superBlack)
            .onAppear(){
                model.start()
            }
            .ignoresSafeArea()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var links: some View {
        VStack {
            NavigationLink(destination: 
                            OnboardingView()
                .navigationBarHidden(true), isActive: $model.onboarding, label: {EmptyView()})
            NavigationLink(destination:
                            TsbViewHarmony()
                .navigationBarHidden(true), isActive: $model.tabPage, label: {EmptyView()})
        }
    }
    
    private var logoPlusProgress: some View {
        VStack {
            Image(StaticValues.logo.logo.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            HStack(spacing: 20){
                
                ProgressView(value: model.timer)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.superWhite))
                    .scaleEffect(x: 1.5, y: 1.5)
                Text("\(convertToPercentage())%")
                    .font(Font.system(size: 17, weight: .regular))
                    .foregroundColor(Color.superWhite)
            }
            .padding()
        }
    }
    private func convertToPercentage() -> Int{
        return Int(model.timer * 100.0)
    }
}

#Preview {
    SplashView()
}
