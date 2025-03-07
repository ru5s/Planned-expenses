//
//  Settings.swift
//  Harmony Leap
//
//  
//

import SwiftUI
import StoreKit

struct Settings: View {
    @State var openUsagePolicy: Bool = false
    @State var usagePolice: String = "https://docs.google.com"
    var body: some View {
        NavigationView {
            ZStack{
                buttons
                shadowTabs
            }
            .sheet(isPresented: $openUsagePolicy, content: {
                WebViewHarmony(link: usagePolice)
            })
            .navigationTitle("Settings")
        }
    }
    
    private var buttons: some View {
        VStack(spacing: 15) {
            boardButton(title: "Share  app", image: "square.and.arrow.up.fill", trigger: .share)
            boardButton(title: "Rate Us", image: "star.fill", trigger: .rate)
            boardButton(title: "Usage Policy", image: "doc.text.fill", trigger: .usagePolicy)
            Spacer()
        }
        .padding(16)
    }
    
    private func boardButton(title: String, image: String, trigger: Trigger) -> some View {
        VStack {
            Button(action: {
                switch trigger {
                case .share:
                    shareApp()
                case .rate:
                    rateApp()
                case .usagePolicy:
                    openUsagePolicy.toggle()
                }
            }, label: {
                VStack {
                    Image(systemName: image)
                        .foregroundColor(Color.superWhite)
                        .font(.title3)
                        .padding(.bottom, 4)
                    
                    Text(title)
                        .font(Font.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.superWhite)

                }
                .frame(height: 100)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.superBlack)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            })
        }
    }
    
    private var shadowTabs: some View {
        VStack {
            Rectangle()
                .frame(height: 2)
                .blur(radius: 8)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .foregroundColor(Color.superBlack.opacity(0.7))
        }
    }
    
    private func shareApp(){
        DispatchQueue.main.async {
            let appStoreURL = URL(string: "https://apps.apple.com")!
            let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY / 2, width: 0, height: 0)
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func rateApp(){
        DispatchQueue.main.async {
            let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive})
            SKStoreReviewController.requestReview(in: scene as! UIWindowScene)
        }
    }
}

#Preview {
    Settings()
}

enum Trigger {
    case share
    case rate
    case usagePolicy
}
