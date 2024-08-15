//
//  Home.swift
//  CreditCards
//
//  Created by Alondra García Morales on 06/08/24.
//

import SwiftUI
import CoreData

struct Home: View {
    
    @FetchRequest(entity: Cards.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], animation: .spring()) var results : FetchedResults<Cards>
    
    
    @State private var copyNumber = UIPasteboard.general
    @StateObject var card = CardsViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    ForEach(results){ item in
                        NavigationLink(value: item){
                            CardView(name: item.name, number: item.number, type: item.type, bankName: item.bankName, expireDate: item.expireDate)
                        }.navigationDestination(for: Cards.self){ item in
                            PurchaseView(card: item)
                        }.contextMenu{
                            Button{
                                card.sendItem(item: item, modal: "edit")
                            } label:{
                                Label("Edit", systemImage: "pencil")
                            }
                            Button{
                                copyNumber.string = item.number
                            } label:{
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            Button(role:.destructive){
                                card.sendItem(item: item, modal: "delete")
                            } label:{
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }.listStyle(.plain)
            }
            .toolbar{
                Button{
                    card.addCardView.toggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(LinearGradient(colors:[.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                }
            }.sheet(isPresented: $card.addCardView){
                AddCardView(cards: card)
                    
            }.sheet(isPresented: $card.showDelete){
                deleteCardView(cards: card)
                    .presentationDetents([.medium])
            }
            .navigationTitle("Credit Cards")
        }
    }
}

struct CardView: View {
    
    var name : String?
    var number : String?
    var type : String?
    var bankName : String?
    var expireDate : String?
    
    @State private var color1 : Color = .red
    @State private var color2 : Color = .orange
    
    ///4 digits
    @State private var creditNumber = ""
    
    
    var body: some View{
        VStack(alignment:.leading){
            HStack{
                Text(bankName ?? "")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold, design: .rounded)).padding()
                Spacer()
                Text(type ?? "")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .italic()
                    .padding()
            }
            Text(creditNumber)
                .foregroundStyle(.white)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .padding()
            HStack{
                VStack(alignment: .leading){
                    Text("Client Name")
                        .opacity(0.5)
                        .font(.system(size: 14))
                    Text(name ?? "")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                Spacer()
                VStack(alignment: .leading){
                    Text("Expires Date")
                        .opacity(0.5)
                        .font(.system(size: 14))
                    Text(expireDate ?? "")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
            }.padding()
        }.frame(width: 300, height: 200)
            .padding(.all)
            .background(LinearGradient(gradient: Gradient(colors:[color1, color2]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onAppear{
                if type == "VISA" || bankName == "BBVA"{
                    color1 = Color(red: 0.42, green: 0.77, blue: 0.86)
                    color2 = Color(red: 0.18, green: 0.56, blue: 0.71)
                }
                else if type == "MASTER CARD"{
                    color1 = Color(red: 0.55, green: 0.55, blue: 0.55)
                    color2 = Color(red: 0.35, green: 0.35, blue: 0.35)
                }
                else{
                    color1 = Color(red: 0.85, green: 0.75, blue: 0.45)
                    color2 = Color(red: 0.95, green: 0.85, blue: 0.5)
                }
                
                creditNumber = number?.replacingOccurrences(of: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})", with: "$1  $2  $3  $4", options: .regularExpression, range: nil) ?? number ?? ""
            }
    }
}
