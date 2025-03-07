//
//  TsbView.swift
//  Harmony Leap
//
//  
//

import SwiftUI

struct TsbViewHarmony: View {
    @State var updateData: Bool = false
    @State var addDebt: Bool = false
    @State var addEntry: Bool = false
    @ObservedObject var homeModel = HomeVIewModel()
    @State var darkBackground: Bool = false
    @State var editEntry: Bool = false
    @State var choosedSubItem: SubItem?
    @State var debtViewUpdate: Bool = false
    var body: some View {
        allTabs
    }
    
    private var allTabs: some View {
        ZStack {
            TabView {
                HomeView(model: homeModel, addDebt: $addDebt, updateData: $updateData, createNewEntry: $addEntry)
                    .tabItem({
                        Label("", systemImage: "house.fill")
                    })
                    .tag(0)
                DebtsVIew(model: homeModel, addDebt: $addDebt, updateData: $debtViewUpdate, createNewEntry: $addEntry, editEntry: $editEntry, choosedSubItem: $choosedSubItem)
                    .tabItem({
                        Label("", systemImage: "doc.text.fill")
                    })
                    .tag(1)
                Settings()
                    .tabItem({
                        Label("", systemImage: "gearshape.fill")
                    })
                    .tag(2)
            }
            .accentColor(Color.buttonGreen)
            .background(Color.superWhite)
            .navigationViewStyle(StackNavigationViewStyle())
            
            if darkBackground {
                Color.superBlack.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            darkBackground.toggle()
                            addDebt = false
                            addEntry = false
                            editEntry = false
                        }
                    }
            }
            
            EditEntry(items: $homeModel.entrys, choosedItem: $homeModel.choosedItem, subItemChoosed: $choosedSubItem, dismiss: $editEntry, updateData: {
                homeModel.getEntrys()
                debtViewUpdate.toggle()
            })
            .padding(.vertical, 16)
            .background(Color.superWhite)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: !editEntry ? 600 : 0)
            .ignoresSafeArea(.container, edges: .bottom)
            
            AddDebt(updateData: {
                updateData.toggle()
                
            }, dismiss: $addDebt)
            .padding(.vertical, 16)
            .background(Color.superWhite)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: !addDebt ? 600 : 0)
            .ignoresSafeArea(.container, edges: .bottom)
        
            AddEntry(items: $homeModel.entrys, choosedItem: $homeModel.choosedItem, dismiss: $addEntry, updateData: {
                updateData.toggle()
                homeModel.getEntrys()
                debtViewUpdate.toggle()
            })
            .padding(.vertical, 16)
            .background(Color.superWhite)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: !addEntry ? 600 : 0)
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .onChange(of: addDebt, perform: { value in
            if value {
                darkBackground = true
            } else {
                withAnimation {
                    darkBackground = false
                }
            }
        })
        .onChange(of: addEntry, perform: { value in
            if value {
                darkBackground = true
            } else {
                withAnimation {
                    darkBackground = false
                }
            }
        })
        .onChange(of: editEntry, perform: { value in
            if value {
                darkBackground = true
            } else {
                withAnimation {
                    darkBackground = false
                }
            }
        })
        .onAppear(){
            homeModel.getEntrys()
        }
    }
}

#Preview {
    TsbViewHarmony()
}
