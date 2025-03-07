//
//  Test.swift
//  Harmony Leap
//
//  Created by Den on 11/04/24.
//

import SwiftUI

import SwiftUI

struct ExpenseItem: Identifiable {
    let id = UUID()
    let spent: Double
}

class ExpenseManager: ObservableObject {
    @Published var expenses: [ExpenseItem] = []
    @Published var totalBudget: Double = 100
    
    // Функция для добавления расхода
    func addExpense(amount: Double) {
        expenses.append(ExpenseItem(spent: amount))
    }
}

struct ContentView: View {
    @StateObject var expenseManager = ExpenseManager()
    @State private var newExpenseAmount: String = ""
    
    var body: some View {
        VStack {
            Text("Total Budget: \(expenseManager.totalBudget)")
                .padding()
            
            TextField("Enter expense amount", text: $newExpenseAmount)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            
            Button("Add Expense") {
                guard let amount = Double(newExpenseAmount) else { return }
                expenseManager.addExpense(amount: amount)
                newExpenseAmount = ""
            }
            .padding()
            
            List {
                ForEach(expenseManager.expenses.indices.reversed(), id: \.self) { index in
                    ExpenseCellView(expenseManager: expenseManager, index: index)
                }
            }
        }
        .padding()
    }
}

struct ExpenseCellView: View {
    @ObservedObject var expenseManager: ExpenseManager
    let index: Int
    
    var body: some View {
        let remainingBudget = expenseManager.totalBudget - expenseManager.expenses.prefix(index + 1).reduce(0) { $0 + $1.spent }
        
        return VStack {
            Text("Expense \(index + 1)")
            Text("Spent: \(expenseManager.expenses[index].spent)")
            Text("Remaining Budget: \(remainingBudget)")
        }
    }
}


#Preview {
    ContentView()
}
