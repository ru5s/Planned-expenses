//
//  AboutCurrency.swift
//  Harmony Leap
//
//  Created by Den on 10/04/24.
//

import SwiftUI

struct AboutCurrency: View {
    @State var data: CurrencyModel
    @Binding var choosedPair: CurrencyModel
    @Binding var dismiss: Bool
    @Binding var backToTabPage: Bool
    @Binding var allDebt: [Item]
    @State var allDebtLoan: Int = 0
    @State var allDebtInChoosedPair: Double = 0
    var body: some View {
        VStack {
            ZStack {
                Text(data.first + "/" + data.second)
                    .foregroundColor(Color.superBlack)
                .padding(.vertical, 5)
                Button(action: {
                    dismiss.toggle()
                }, label: {
                    Image(systemName: "chevron.left")
                })
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Text("The balance of the debt")
                .font(Font.system(size: 17, weight: .regular))
                .foregroundColor(Color.buttonGreen)
                .padding(.bottom, 5)
            HStack(alignment: .firstTextBaseline){
                VStack(alignment: .leading){
                    Text("Us dollar")
                        .font(Font.system(size: 15, weight: .regular))
                        .foregroundColor(Color.categoryGray)
                        .frame(maxWidth: 200, alignment: .leading)
                    Text("$ \(allDebtLoan)")
                        .font(Font.system(size: 17, weight: .regular))
                        .foregroundColor(Color.superBlack)
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text("\(data.fullName)")
                        .font(Font.system(size: 15, weight: .regular))
                        .foregroundColor(Color.categoryGray)
                        .frame(maxWidth: 200, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                    Text("\(data.icon) \(Int(allDebtInChoosedPair))")
                        .font(Font.system(size: 17, weight: .regular))
                        .foregroundColor(Color.superBlack)
                }
            }
            .padding(.bottom, 15)
            Image(StaticValues.elements.graph.rawValue)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, -16)
            
            HStack {
                Button(action: {
                    dismiss.toggle()
                }, label: {
                    Text("Back")
                        .foregroundColor(Color.superWhite)
                        .padding(16)
                        .frame(maxWidth: 120)
                        .background(Color.simpleRed)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
                })
                
                Button(action: {
                    choosedPair = data
                    backToTabPage.toggle()
                    dismiss.toggle()
                }, label: {
                    Text("Apply")
                        .foregroundColor(Color.superWhite)
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.simpleGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
                })
            }
            .padding(.vertical, 20)
        }
        .padding(.horizontal, 16)
        .onAppear() {
            allDebtLoan = 0
            for item in allDebt {
                allDebtLoan += Int(item.debt)
            }
            allDebtInChoosedPair = Double(allDebtLoan) * data.approximateСoefficient
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    AboutCurrency(data: .init(id: 0, first: "USD", second: "EUR", fullName: "Euro", approximateСoefficient: 0.92, icon: "€"), choosedPair: .constant(.init(id: 0, first: "USD", second: "EUR", fullName: "Euro", approximateСoefficient: 0.92, icon: "€")), dismiss: .constant(false), backToTabPage: .constant(false), allDebt: .constant([]))
}
