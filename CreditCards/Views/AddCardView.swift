//
//  AddCardView.swift
//  CreditCards
//
//  Created by Alondra García Morales on 06/08/24.
//

import SwiftUI

struct AddCardView: View {
    @State private var isPressed = false
    @Environment(\.managedObjectContext) private var context
    @StateObject var cards : CardsViewModel
    let types = ["VISA", "MASTER CARD", "AMERICAN EXPRESS"]
    @State private var error = false
    @State private var msgError = "Something ocured..."
    
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text(cards.bankName == "" ? "" : cards.bankName)
                        .font(.system(size: 18, weight: .bold, design: .rounded)).padding()
                    Spacer()
                    Text(cards.type == "" ? "" : cards.type)
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .italic()
                        .padding()
                }
                Text(cards.number == "" ? "" : cards.number )
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .padding()
                HStack{
                    VStack(alignment: .leading){
                        Text("Client Name")
                            .opacity(0.5)
                            .font(.system(size: 14))
                        Text(cards.name == "" ? "" : cards.name)
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Expires Date")
                            .opacity(0.5)
                            .font(.system(size: 14))
                        Text(cards.expireDate == "" ? "" : cards.expireDate)
                    }
                }.padding()
            }.foregroundStyle(.white)
                .frame(width: 350, height: 250)
                .background{
                    LinearGradient(colors:[.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .padding()
            ///////////////////////
            VStack(alignment:.leading){
                Text(cards.updateItem == nil ? "Add Credit Card" : "Edit Credit Card")
                    .font(.title)
                    .foregroundStyle(.black)
                    .bold()
                TextField("Client Name", text: $cards.name)
                    .textFieldStyle(.roundedBorder)
                TextField("Card Number", text: $cards.number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .disabled(cards.number.count >= 16)
                TextField("Bank Name", text: $cards.bankName)
                    .textFieldStyle(.roundedBorder)
                TextField("Expire Date", text: $cards.expireDate)
                    .textFieldStyle(.roundedBorder)
                TextField("Credit Limit", text: $cards.credit)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                Picker("", selection: $cards.type){
                    ForEach(types, id:\.self){
                        Text($0)
                    }
                }.pickerStyle(.segmented)
                
                Button {
                            withAnimation {
                                isPressed.toggle()
                            }
                            if cards.updateItem == nil {
                                cards.saveCard(context: context) { done in
                                    if done {
                                        cards.addCardView.toggle()
                                    } else {
                                        error.toggle()
                                    }
                                }
                            } else {
                                cards.editCard(context: context) { done in
                                    if done {
                                        cards.addCardView.toggle()
                                    } else {
                                        error.toggle()
                                    }
                                }
                            }
                        } label: {
                            Text(cards.updateItem == nil ? "Save Card" : "Edit Card")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(isPressed ? Color.purple : Color.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    Group {
                                        if isPressed {
                                            Color.white
                                        } else {
                                            LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        }
                                    }
                                )
                                .cornerRadius(15)
                                
                        }
                        .buttonStyle(PlainButtonStyle())
                        .animation(.easeInOut(duration: 0.2), value: isPressed) // Optional, for smoother animation
                        .padding(.top, 40)
                        
                
            }.padding(.all)
                .alert(msgError, isPresented: $error){
                    Button("Acept", role:.cancel){
                        
                    }
                }
        }.ignoresSafeArea(.all)
            .onDisappear{
                cards.name = ""
                cards.type = ""
                cards.bankName = ""
                cards.credit = ""
                cards.expireDate = ""
                cards.number = ""
                cards.updateItem = nil
            }
    }
}


