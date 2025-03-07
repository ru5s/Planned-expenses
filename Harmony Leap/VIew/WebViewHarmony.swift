//
//  WebViewHarmony.swift
//  Harmony Leap
//
//  
//

import SwiftUI

struct WebViewHarmony: View {
    @State var link: String
    var body: some View {
        ZStack {
            Color.superWhite
                .ignoresSafeArea()
            browser
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var browser: some View {
        VStack {
            WebView(stringUrl: link)
        }
    }
}

#Preview {
    WebViewHarmony(link: "https://gmail.com")
}
