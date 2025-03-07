//
//  CustomPicker.swift
//  Harmony Leap
//
//  Created by Den on 09/04/24.
//

import SwiftUI

import SwiftUI

struct CustomPicker: View {
    @Binding var dismis: Bool
    @State private var title: String = "Category"
    @State var confirm: (Item) -> Void
    @Binding var items: [Item]
    var body: some View {
        ZStack {
            if dismis {
                GeometryReader(content: { geometry in
                    VStack {
                        Text(title)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                            .padding(.horizontal, 20)
                            .foregroundColor(Color.categoryGray)
                        
                        ForEach(items, id: \.id) {type in
                            Button(action: {
                                confirm(type)
                                dismis.toggle()
                            }, label: {
                                VStack {
                                    Divider()
                                    Text(type.category ?? "")
                                        .font(Font.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.superBlack)
                                }
                            })
                        }
                    }
                    .padding(.vertical, 20)
                    .foregroundColor(Color.superWhite)
                    .frame(maxWidth: geometry.size.width - 200)
                    .background(Color.superWhite)
                    .cornerRadius(16)
                    .position(x: geometry.frame(in: .local).width / 2, y: geometry.frame(in: .local).height / 2)
                    .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0.0, y: 0.0)
                    .offset(y: -((geometry.size.height / 2) + 20))
                })
                .onTapGesture {
                    dismis.toggle()
                }
            }
        }
    }
}

#Preview {
    CustomPicker(dismis: .constant(true), confirm: {_ in}, items: .constant([]))
}

