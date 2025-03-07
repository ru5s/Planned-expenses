//
//  SplashCell.swift
//  Harmony Leap
//
//  
//

import SwiftUI

struct OnboardingCell: View {
    @State var item: OnboardingModel
    @State var itemCount: Int
    @Binding var activeDot: Int
    @State var showTabView: Bool = false
    
    var body: some View {
        ZStack {
            links
            image
            VStack {
                title
                Spacer()
                button
            }
        }
    }
    private var links: some View {
        VStack {
            NavigationLink(isActive: $showTabView, destination: {
                TsbViewHarmony()
                    .navigationBarHidden(true)
            }, label: {EmptyView()})
        }
    }
    private var image: some View {
        VStack {
            Image(item.image)
                .resizable()
                .scaledToFill()
        }
    }
    private var title: some View {
        VStack {
            Text(item.title)
                .font(Font.system(size: 48, weight: .black))
                .foregroundColor(Color.superWhite)
                .multilineTextAlignment(.center)
                .padding(.top, 50)
        }
    }
    private var button: some View {
        VStack {
            dots
                .padding(.top, 15)
            Button(action: {
                if activeDot < itemCount - 1 {
                    activeDot += 1
                } else {
                    showTabView = true
                    saveState()
                }
            }, label: {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.buttonGreen)
                    .overlay(
                        Text(item.buttonTitle)
                            .font(Font.system(size: 17, weight: .semibold))
                            .foregroundColor(Color.superWhite)
                    )
            })
            .frame(height: 50)
            .padding(.bottom, 54)
            .padding(.top, 20)
        }
        .padding(16)
        .background(Color.superWhite)
    }
    private var dots: some View {
        HStack {
            ForEach(0..<itemCount, id: \.self) { int in
                RoundedRectangle(cornerRadius: 50, style: .circular)
                    .fill(int == activeDot ? Color.buttonGreen : Color.passiveTabGreen)
                    .frame(width: 8, height: 8, alignment: .center)
                    
            }
        }
    }
    private func saveState(){
        let userDefaults = UserDefaults()
        userDefaults.setValue(true, forKey: StaticValues.show.onboarding.rawValue)
    }
}

#Preview {
    OnboardingCell(item: .init(image: StaticValues.onboarding.slide0.rawValue, title: "Control your \n credit", buttonTitle: "Next"), itemCount: 3, activeDot: .constant(2))
}
