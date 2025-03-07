//
//  CurrencyPairCell.swift
//  Harmony Leap
//
//  Created by Den on 10/04/24.
//

import SwiftUI

struct CurrencyPairCell: View {
    @State var data: CurrencyModel
    @Binding var choosedPair: CurrencyModel
    @State var openAboutPair: Bool = false
    @Binding var dismiss: Bool
    @Binding var allDebt: [Item]
    var body: some View {
        Button(action: {
            openAboutPair.toggle()
        }, label: {
            HStack {
                HStack(spacing: 0) {
                    Image(data.first)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                    Image(data.second)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                        .padding(.leading, -14)
                        .padding(.bottom, -28)
                }
                .padding(.bottom, 19)
                ZStack(alignment: .bottom) {
                    HStack {
                        Text(data.first + "/" + data.second)
                            .foregroundColor(Color.superWhite)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(data.fullName)
                                .foregroundColor(Color.superWhite)
                                .font(Font.system(size: 17))
                            Text("$" + data.approximateСoefficient.description)
                                .foregroundColor(Color.simpleGreen)
                                .font(Font.system(size: 14))
                        }
                        .padding(.horizontal, 10)
                        Text(data.icon)
                            .foregroundColor(Color.gray)
                            .font(Font.system(size: 20))
                    }
                    .frame(height: 60)
                }
            }
            .padding(16)
            .background(Color.superBlack)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
        })
        .sheet(isPresented: $openAboutPair, content: {
            AboutCurrency(data: data, choosedPair: $choosedPair, dismiss: $openAboutPair, backToTabPage: $dismiss, allDebt: $allDebt)
        })
    }
}

#Preview {
    CurrencyPairCell(data: .init(id: 0, first: "USD", second: "EUR", fullName: "Euro", approximateСoefficient: 0.92, icon: "€"), choosedPair: .constant(.init(id: 0, first: "USD", second: "EUR", fullName: "Euro", approximateСoefficient: 0.92, icon: "€")), dismiss: .constant(false), allDebt: .constant([]))
}
