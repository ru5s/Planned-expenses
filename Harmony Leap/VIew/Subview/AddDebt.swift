//
//  AddEntrys.swift
//  Harmony Leap
//
//  
//

import SwiftUI

struct AddDebt: View {
    @State var category = ""
    @State var loanAmount: String = ""
    @State var loanTerm: String = ""
    @State var interestRate: String = ""
    @State var finalCalculate: Double = 0.0
    @State var result: Double = 0.0
    @State var disableButton: Bool = true
    @State var updateData: () -> Void
    @Binding var dismiss: Bool
    var body: some View {
        GeometryReader { geometry in
            VStack {
                title
                
                inputFields
                loanBalance
                roundButton
            }
            .padding(.horizontal, 16)
            .onChange(of: dismiss, perform: { value in
                if value {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    category = ""
                    loanTerm = ""
                    interestRate = ""
                    loanAmount = ""
                } else {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            })
            .gesture(DragGesture()
                .onChanged { value in
                    if value.startLocation.y < value.location.y {
                        withAnimation {
                            dismiss = false
                        }
                    }
                }
            )
        }
        .frame(maxHeight: 400)
    }
    private var title: some View {
        VStack{
            RoundedRectangle(cornerRadius: 25.0, style: .circular)
                .fill(Color.categoryGray)
                .frame(width: 35, height: 5, alignment: .center)
            Text("Add debt")
                .font(Font.system(size: 17, weight: .semibold))
                .foregroundColor(Color.superBlack)
                .padding(.horizontal, 15)
        }
    }
    
    private var inputFields: some View {
        VStack {
            field(text: $category, title: "Category", keyboard: .default)
            field(text: $loanAmount, title: "Loan amount", keyboard: .decimalPad)
                .onChange(of: loanAmount, perform: { value in
                    loanAmount = value.replacingOccurrences(of: ",", with: ".")
                    calculate()
                })
            field(text: $loanTerm, title: "Loan term (number of months)", keyboard: .decimalPad)
                .onChange(of: loanTerm, perform: { value in
                    loanTerm = value.replacingOccurrences(of: ",", with: ".")
                    calculate()
                })
            field(text: $interestRate, title: "The interest rate", keyboard: .decimalPad)
                .onChange(of: interestRate, perform: { value in
                    interestRate = value.replacingOccurrences(of: ",", with: ".")
                    calculate()
                })
        }
    }
    
    private var roundButton: some View {
        VStack {
            Button(action: {
                saveToCoreData()
                updateData()
                dismiss.toggle()
            }, label: {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(disableButton ? Color.passiveTabGreen : Color.buttonGreen)
                    .frame(height: 54)
                    .overlay(
                        Text("Add")
                            .font(Font.system(size: 17, weight: .semibold))
                            .foregroundColor(Color.superWhite)
                    )
            })
            .disabled(disableButton)
            .padding(.top, 5)
            .padding(.bottom, 50)
        }
    }
    
    private var loanBalance: some View {
        HStack{
            Text("Loan balance")
                .font(Font.system(size: 17, weight: .regular))
                .foregroundColor(Color.categoryGray)
            Spacer()
            Text("$ \(finalCalculate.rounded().description)")
                .font(Font.system(size: 17, weight: .regular))
                .foregroundColor(Color.categoryGray)
        }
    }
    
    private func field(text: Binding<String>, title: String, keyboard: UIKeyboardType) -> some View {
        VStack {
            TextField("", text: text)
                .placeholder(when: text.wrappedValue.isEmpty) {
                    Text(title)
                        .foregroundColor(Color.categoryGray)
                }
                .padding(10)
                .font(Font.system(size: 17, weight: .regular))
                .foregroundColor(Color.superBlack)
                .background(Color.white)
                .keyboardType(keyboard)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(2)
        .background(Color.passiveTabGreen)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private func calculate(){
        if !loanTerm.isEmpty && !interestRate.isEmpty && !interestRate.isEmpty {
            let monthInterestRate = (Double(interestRate) ?? 0.0) / 12 / 100
            let raiseToADegree = pow((1 + monthInterestRate), Double(loanTerm) ?? 0.0)
            let monthlyPayment = (Double(loanAmount) ?? 0.0) * (monthInterestRate + (monthInterestRate / (raiseToADegree - 1)))
            let result = (monthlyPayment * 100).rounded() / 100
            finalCalculate = result * (Double(loanTerm) ?? 0.0)
            disableButton = false
        } else {
            finalCalculate = 0.0
            disableButton = true
        }
    }
    
    private func saveToCoreData(){
        CoreDataService.shared.saveItem(category: category, loanAmount: Double(loanAmount) ?? 0.0, loanTerm: Double(loanTerm) ?? 0.0, interestRate: Double(interestRate) ?? 0.0, loanBalancePlusPerc: finalCalculate.rounded(), debt: finalCalculate.rounded())
    }
}

#Preview {
    AddDebt(updateData: {}, dismiss: .constant(true))
}
