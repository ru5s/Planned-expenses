//
//  CurrencyPair.swift
//  Harmony Leap
//
//  Created by Den on 10/04/24.
//

import SwiftUI

struct CurrencyPair: View {
    @Binding var choosedPair: CurrencyModel
    @ObservedObject var model: HomeVIewModel
    @Binding var dismiss: Bool
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(model.currencyPair, id: \.id) { data in
                        CurrencyPairCell(data: data, choosedPair: $choosedPair, dismiss: $dismiss, allDebt: $model.entrys)
                    }
                }
                .background(Color.superWhite)
                .cornerRadius(10)
            }
            .navigationTitle("Currency change")
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    CurrencyPair(choosedPair: .constant(.init(id: 0, first: "USD", second: "EUR", fullName: "Euro", approximateСoefficient: 0.92, icon: "€")), model: HomeVIewModel(), dismiss: .constant(false))
}
