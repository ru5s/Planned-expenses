//
//  EditEntry.swift
//  Harmony Leap
//
//  Created by Den on 10/04/24.
//

import SwiftUI

struct EditEntry: View {
    @Binding var items: [Item]
    @Binding var choosedItem: Item?
    @Binding var subItemChoosed: SubItem?
    @State var paymentAmount: String = ""
    @State var loanBalanceDouble: Double = 0.0
    @State var disableButton: Bool = true
    @Binding var dismiss: Bool
    @State var updateData: () -> Void
    @State var customPicker: Bool = false
    @State var currentDate: Date = Date()
    @State var choosedDate: Bool = false
    @State var alert: Bool = false
    @State var enterWithNil: Bool = false
    @State var titleString: String = "Editig"
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    title
                    inputFields
                    loanBalance
                    roundButton
                    alertMessage("Your payment is more than required")
                        .opacity(alert ? 1.0 : 0.0)
                }
                .padding(.horizontal, 16)
                .background(Color.superWhite)
                .onAppear(){
                    
                    
                }
                .onChange(of: subItemChoosed, perform: { value in
                    if subItemChoosed != nil {
                        currentDate = subItemChoosed?.dateOfPayment ?? Date()
                        paymentAmount = String(subItemChoosed?.paymantAmount ?? 0)
                        let debt = (choosedItem?.debt ?? 0)
                        loanBalanceDouble = debt
                    }
                })
                .onChange(of: dismiss, perform: { value in
                    customPicker = false
                    if choosedItem == nil {
                        paymentAmount = ""
                        enterWithNil = true
                    } else {
                        enterWithNil = false
                    }
                    if value {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } else {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                })
                .onChange(of: paymentAmount, perform: { value in
                    let debt = (choosedItem?.debt ?? 0) + (subItemChoosed?.paymantAmount ?? 0) - (Double(value) ?? 0)
                    loanBalanceDouble = debt
                    checkFields()
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
                .onTapGesture {
                    customPicker = false
                }
            }
        }
        .frame(maxHeight: 400)
    }
    private func alertMessage(_ message: String) -> some View {
        VStack{
            Text(message)
                .font(Font.system(size: 17, weight: .regular))
                .foregroundColor(Color.superBlack)
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.superWhite)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(16)
                .shadow(color: .gray, radius: 10, x: 0.0, y: 0.0)
            Spacer()
        }
    }
    
    private var title: some View {
        VStack{
            RoundedRectangle(cornerRadius: 25.0, style: .circular)
                .fill(Color.categoryGray)
                .frame(width: 35, height: 5, alignment: .center)
            Text(titleString)
                .font(Font.system(size: 17, weight: .semibold))
                .foregroundColor(Color.superBlack)
                .padding(.horizontal, 15)
        }
    }
    
    private var inputFields: some View {
        VStack {
            picker
            field(text: $paymentAmount, title: "Payment amount", keyboard: .decimalPad)
            datePicker
        }
    }

    private var datePicker: some View {
        VStack {
            HStack {
                Text("Date of payment")
                    .foregroundColor(choosedDate ? Color.superBlack : Color.categoryGray)
                
                ZStack(alignment: .trailing, content: {
                    DatePicker("",
                               selection: $currentDate,
                               displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .blendMode(.color)
                    .opacity(0.7)
                    
                    Text(choosedDate ? formatterDate(currentDate) : formatterDate(Date()))
                        .foregroundColor(Color.superBlack)
                        .padding(5)
                        .background(Color.passiveTabGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .allowsHitTesting(false)
                    
                })
                .onChange(of: currentDate, perform: { value in
                    withAnimation {
                        choosedDate = true
                    }
                })
            }
            .padding(10)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(2)
        .background(Color.passiveTabGreen)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private var roundButton: some View {
        VStack {
            Button(action: {
                saveToCoreData()
                dismiss.toggle()
            }, label: {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(disableButton ? Color.passiveTabGreen : Color.buttonGreen)
                    .frame(height: 54)
                    .overlay(
                        Text("Save")
                            .font(Font.system(size: 17, weight: .semibold))
                            .foregroundColor(Color.superWhite)
                    )
            })
            .disabled(disableButton)
            .padding(.top, 5)
            .padding(.bottom, 50)
        }
    }
    
    private var picker: some View {
        VStack {
            HStack {
                HStack {
                    Text(choosedItem?.category ?? "")
                        .font(Font.system(size: 17, weight: .regular))
                        .foregroundColor(Color.superBlack.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(Color.categoryGray.opacity(0.3))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(10)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .onTapGesture {
                withAnimation {
                    customPicker.toggle()
                }
            }
        }
        .padding(2)
        .background(Color.passiveTabGreen)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private var loanBalance: some View {
        HStack{
            Text("Loan balance")
                .font(Font.system(size: 17, weight: .regular))
                .foregroundColor(Color.categoryGray)
            Spacer()
            Text("$ \(loanBalanceDouble.description)")
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
                .frame(height: 50)
                .foregroundColor(Color.superBlack)
                .background(Color.white)
                .keyboardType(keyboard)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(2)
        .background(Color.passiveTabGreen)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private func checkFields(){
        
        if !paymentAmount.isEmpty && choosedItem != nil && loanBalanceDouble >= 0 {
            disableButton = false
        } else {
            disableButton = true
        }
    }

    private func saveToCoreData(){
        choosedItem?.debt += subItemChoosed?.paymantAmount ?? 0
        subItemChoosed?.dateOfPayment = currentDate
        subItemChoosed?.paymantAmount = Double(paymentAmount) ?? 0
        choosedItem?.debt -= Double(paymentAmount) ?? 0
        try? CoreDataService.shared.save()
        if enterWithNil {
            choosedItem = nil
        }
        updateData()
    }
    
    private func formatterDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
}

#Preview {
    TsbViewHarmony()
}
