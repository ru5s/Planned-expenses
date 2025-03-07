//
//  DebtCell.swift
//  Harmony Leap
//
//  
//

import SwiftUI

struct DebtCell: View {
    @State var subView: SubItem?
    @State var date = Date()
    @State var amount: Int = 0
    @State var currentResult: Double = 0
    @Binding var updateData: Bool
    @State var index: Int = 0
    @State var allItems: [SubItem] = []
    var body: some View {
        VStack {
            HStack {
                if let subView = subView {
                    
                    VStack(alignment: .leading) {
                        Text("$ \(amount)")
                            .font(Font.system(size: 17, weight: .semibold))
                            .foregroundColor(Color.superBlack)
                        Text(subView.category ?? "")
                            .font(Font.system(size: 16, weight: .regular))
                            .foregroundColor(Color.passiveTabGreen)
                    }
                    Spacer()
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(formatterDate(date))
                            .font(Font.system(size: 16, weight: .regular))
                            .foregroundColor(Color.superWhite)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.passiveTabGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 4, style: .circular))
                        Text("Loan balance")
                            .font(Font.system(size: 16, weight: .regular))
                            .foregroundColor(Color.passiveTabGreen)
                        Text("$ \(currentResult.description)")
                            .font(Font.system(size: 16, weight: .regular))
                            .foregroundColor(Color.superBlack)
                    }
                    .onAppear(){
                        date = allItems[index].dateOfPayment ?? Date()
                        let remainingBudget = Double(amount) - allItems.prefix(index + 1).reduce(0) { $0 + $1.paymantAmount }
                        currentResult = remainingBudget
                    }
                    .onChange(of: updateData, perform: { value in
                        date = allItems[index].dateOfPayment ?? Date()
                        let remainingBudget = Double(amount) - allItems.prefix(index + 1).reduce(0) { $0 + $1.paymantAmount }
                        currentResult = remainingBudget
                    })
                }
            }
            Divider()
                .offset(y: 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        
    }
    
    private func formatterDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
}

//#Preview {
//    DebtCell(subView: .init(context: CoreDataService.shared.container.viewContext), reminder: .constant(100))
//}
#Preview {
    TsbViewHarmony()
}
