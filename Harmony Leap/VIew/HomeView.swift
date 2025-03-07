//
//  HomeView.swift
//  Harmony Leap
//
//  
//

import SwiftUI

struct HomeView: View {
    @State var allAmount: Int = 0
    @State var openCurrencyPair: Bool = false
    @State var choosedCurrency: CurrencyModel = .init(id: 0, first: "USD", second: "EUR", fullName: "US dollar", approximateСoefficient: 1.18, icon: "€")
    @ObservedObject var model: HomeVIewModel
    @State var reminder: Int = 0
    @Binding var addDebt: Bool
    @Binding var updateData: Bool
    @State var alert: Bool = false
    @Binding var createNewEntry: Bool
    var body: some View {
        NavigationView {
            ZStack{
                links
                Color.backgroundGray
                    .ignoresSafeArea()
                VStack {
                    generalPanel
                    currencyPair
                    hostory
                    categorySubItems
                        .padding(.bottom, -35)
                        .ignoresSafeArea(.container, edges: .bottom)
                }
                .padding(.horizontal, 16)
                shadowTabs
                alertMessage("Add new debt first")
                    .opacity(alert ? 1.0 : 0.0)
                    .frame(maxHeight: .infinity)
                
            }
            .navigationTitle("Home")
            .navigationBarTitleTextColor(Color.superBlack)
        }
        .onAppear() {
            model.getEntrys()
            if model.entrys.count > 0 {
                model.choosedItem = model.entrys.first
            }
        }
        .onChange(of: model.entrys, perform: { value in
            if model.entrys.count > 0 {
                model.choosedItem = model.entrys.first
            }
        })
        .onChange(of: updateData, perform: { value in
            model.getEntrys()
        })
        .onChange(of: model.choosedItem, perform: { value in
            if model.choosedItem != nil {
            }
        })
    }

    private var links: some View {
        NavigationLink(isActive: $openCurrencyPair, destination: {CurrencyPair(choosedPair: $choosedCurrency, model: model, dismiss: $openCurrencyPair)}, label: {EmptyView()})
    }
    
    private func alertMessage(_ message: String) -> some View {
        VStack{
            Text(message)
                .font(Font.system(size: 17, weight: .regular))
                .foregroundColor(Color.superBlack)
                .padding(20)
                .background(Color.superWhite)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(16)
                .shadow(color: .gray, radius: 10, x: 0.0, y: 0.0)
        }
    }
    
    private var emptyData: some View {
        VStack {
            Text("Add a new entry")
                .font(Font.system(size: 20, weight: .semibold))
                .foregroundColor(Color.superBlack)
            Button(action: {
                if model.entrys.count == 0 {
                    withAnimation {
                        alert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.alert = false
                        })
                    }
                    
                } else {
                    addNewEntry()
                }
            }, label: {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.buttonGreen)
                    .frame(width: 56, height: 56, alignment: .center)
                    .overlay (
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(Color.superWhite)
                    )
                    .padding(.horizontal, 26)
            })
            
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
    
    private var hostory: some View {
        VStack(spacing: 0) {
            HStack {
                Text("History")
                    .font(Font.system(size: 28, weight: .bold))
                    .foregroundColor(Color.superBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if model.choosedItem != nil && model.choosedItem?.subitem?.count != 0 {
                    Button(action: {
                        if model.choosedItem?.debt ?? 0 != 0 {
                            addNewEntry()
                        }
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(model.choosedItem?.debt ?? 0 != 0 ? Color.buttonGreen : Color.gray)
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            ScrollView(.horizontal, showsIndicators: false, content: {
                LazyHStack {
                    ForEach(Array(model.entrys.enumerated()), id: \.element.id) {index, entry in
                        Button(action: {
                            model.choosedItem = entry
                        }, label: {
                            Text(entry.category ?? "")
                                .font(Font.system(size: 16, weight: .semibold))
                                .foregroundColor(entry == model.choosedItem ? Color.superBlack : Color.categoryGray)
                        })
                    }
                }
            })
            .frame(height: 50)
        }
    }
    
    
    private var categorySubItems: some View {
        VStack{
            if model.choosedItem == nil || model.choosedItem?.subitem?.count == 0 || model.entrys.count == 0 {
               emptyData
                    .padding(.bottom, 120)
            } else {
                ScrollView(.vertical, showsIndicators: false, content: {
                    if model.choosedItem?.subitem?.count ?? 0 != 0 {
                        if model.choosedItem?.debt ?? 0 == 0 {
                            Button(action: {
                                CoreDataService.shared.removeItemFromCoreData(id: model.choosedItem?.id ?? UUID())
                                model.getEntrys()
                                if model.entrys.count > 0 {
                                    model.choosedItem = model.entrys.first
                                }
                            }, label: {
                                Text("The debt has been repaid. Delete it?")
                                    .font(Font.system(size: 15, weight: .regular))
                                    .foregroundColor(Color.gray)
                            })
                        }
                        collections(data: $model.choosedItem)
                            .onChange(of: model.choosedItem, perform: { value in
                                model.getEntrys()
                            })
                    }
                    
                })
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    func sortArrayByDate(_ array: [SubItem]) -> [SubItem] {
        return array.sorted { $0.dateOfPayment ?? Date() < $1.dateOfPayment ?? Date() }
    }
    
    private func collections(data: Binding<Item?>) -> some View {
        LazyVStack{
            let sortedArray = sortArrayByDate(data.wrappedValue?.subitem?.allObjects as? [SubItem] ?? [])

            ForEach(Array(sortedArray.enumerated().reversed()), id: \.element.subId) {index, subItem in
                DebtCell(subView: subItem, amount: Int(model.choosedItem?.loanBalancePlusPercent ?? 0), updateData: $updateData, index: index, allItems: sortedArray)
                }
        }
        .background(model.choosedItem == nil ? Color.clear : Color.superWhite)
        .cornerRadius(16)
        .padding(.bottom, 120)
    }
    
    private var currencyPair: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.superBlack)
            .frame(height: 62)
            .overlay (
                ZStack {
                    HStack {
                        HStack(spacing: 0) {
                            Image(choosedCurrency.first)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 28)
                            Image(choosedCurrency.second)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 28)
                                .padding(.leading, -14)
                                .padding(.bottom, -28)
                        }
                        .padding(.bottom, 19)
                        Text("EUR/USD")
                            .font(Font.system(size: 13, weight: .semibold))
                        .foregroundColor(Color.superWhite)
                    }
                    Button(action: {
                        openCurrencyPair.toggle()
                    }, label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.superWhite)
                            .frame(width: 20)
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(10)
                }
            )
    }
    
    private var generalPanel: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.superBlack)
            .frame(height: 116)
            .overlay(
                HStack {
                    Image(StaticValues.elements.abstract.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, -40)
                    
                    VStack(alignment: .trailing) {
                        Text("Your debt")
                            .font(Font.system(size: 16, weight: .regular))
                            .foregroundColor(Color.superWhite)
                        Text("$\(Int((model.choosedItem != nil) ? (model.choosedItem?.debt.rounded() ?? 0) : (0)))")
                            .font(Font.system(size: 28, weight: .bold))
                            .foregroundColor(Color.superWhite)
                            .lineLimit(1)
                    }
                    Button(action: {
                        withAnimation {
                            addDebt.toggle()
                        }
                    }, label: {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.superWhite)
                            .frame(width: 56, height: 56, alignment: .center)
                            .overlay (
                                Image(systemName: "plus")
                                    .font(.title2)
                            )
                            .padding(.horizontal, 26)
                    })
                    
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        
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
    
    private func addNewEntry() {
        withAnimation {
            createNewEntry = true
        }
    }
}

#Preview {
//    HomeView(model: HomeVIewModel(), addDebt: .constant(false), updateData: .constant(false), createNewEntry: .constant(false))
    TsbViewHarmony()
}
