//
//  DebtsVIew.swift
//  Harmony Leap
//
//  
//

import SwiftUI
import CoreData

struct DebtsVIew: View {
    @State var allAmount: Int = 0
    @State var openCurrencyPair: Bool = false
    @ObservedObject var model: HomeVIewModel
    @State var reminder: Int = 0
    @Binding var addDebt: Bool
    @Binding var updateData: Bool
    @State var alert: Bool = false
    @Binding var createNewEntry: Bool
    @Binding var editEntry: Bool
    @Binding var choosedSubItem: SubItem?
    @State var deleteAlert: Bool = false
    var body: some View {
        NavigationView {
            ZStack{
                Color.backgroundGray
                    .ignoresSafeArea()
                VStack {
                    hostory
                    categorySubItems
                }
                .padding(.horizontal, 16)
                .padding(.bottom, -35)
                .ignoresSafeArea(.container, edges: .bottom)
                
                shadowTabs
                alertMessage("Add new debt first")
                    .opacity(alert ? 1.0 : 0.0)
                    .frame(maxHeight: .infinity)
                
            }
            .navigationTitle("Debts")
            .navigationBarTitleTextColor(Color.superBlack)
        }
        .onAppear() {
            model.getEntrys()
            if model.entrys.count > 0 {
                model.choosedItem = model.entrys.first
                reminder = Int(model.choosedItem?.loanBalancePlusPercent ?? 0.0)
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
                reminder = Int(model.choosedItem?.loanBalancePlusPercent ?? 0.0)
            }
        })
        .alert(isPresented: $deleteAlert, content: {
            Alert(title: Text("Delete a payment"),message: Text("Are you sure you want to delete the payment?"), primaryButton: .destructive(
                Text("Delete")
                    .foregroundColor(Color.red)
                , action: {
                    model.choosedItem?.debt += choosedSubItem?.paymantAmount ?? 0
                    CoreDataService.shared.removeSubItemFromCoreData(id: choosedSubItem?.subId ?? UUID())
                    updateData.toggle()
                    
            }), secondaryButton: .cancel())
            
        })
        

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
                Button(action: {
                    withAnimation {
                        addDebt.toggle()
                    }
                }, label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundColor(Color.superBlack)
                })
                ScrollView(.horizontal, showsIndicators: false, content: {
                    LazyHStack {
                        ForEach(Array(model.entrys.enumerated()), id: \.element.id) {index, entry in
                            Button(action: {
                                model.choosedItem = entry
                                reminder = Int(model.choosedItem?.loanBalancePlusPercent ?? 0.0)
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
            HStack {
                Text("$ \(Int((model.choosedItem?.debt ?? 0).rounded()))")
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
                            .foregroundColor(model.choosedItem?.debt ?? 0 != 0 ? Color.superBlack : Color.gray)
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
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
                        if model.choosedItem != nil {
                            collections(data: $model.choosedItem)
                                .onChange(of: model.choosedItem, perform: { value in
                                    model.getEntrys()
                                })
                        }
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
        LazyVStack(spacing: 0){
            let sortedArray = sortArrayByDate(data.wrappedValue?.subitem?.allObjects as? [SubItem] ?? [])

            ForEach(Array(sortedArray.enumerated().reversed()), id: \.element.subId) {index, subItem in
                DebtCell(subView: subItem, amount: Int(model.choosedItem?.loanBalancePlusPercent ?? 0), updateData: $updateData, index: index, allItems: sortedArray)
                    .addButtonActions(leadingButtons: [], trailingButton: [.edit, .delete]) { type in
                        if type == .edit {
                            if model.choosedItem?.debt ?? 0 != 0 {
                                choosedSubItem = subItem
                                withAnimation {
                                    editEntry.toggle()
                                }
                            }
                        }
                        if type == .delete {
                            choosedSubItem = subItem
                            deleteAlert.toggle()
                        }
                    }
            }
        }
        .background(model.choosedItem == nil ? Color.clear : Color.superWhite)
        .cornerRadius(16)
        .padding(.bottom, 120)
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
    TsbViewHarmony()
}
