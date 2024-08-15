//
//  PurchaseView.swift
//  CreditCards
//
//  Created by Alondra García Morales on 13/08/24.
//

import SwiftUI

struct PurchaseView: View {
    
    var card : Cards
    @Environment(\.managedObjectContext) private var context
    @State private var addPurchase = false
    
    @State private var total : Int16 = 0
    @State private var resto : Int16 = 0
    
    @StateObject var purchase = PurchasesViewModel()
    
    var purchases : FetchRequest<Purchases>
    init(card: Cards) {
        self.card = card
        purchases = FetchRequest<Purchases>(entity: Purchases.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], predicate: NSPredicate(format: "idCard == %@", card.id! as CVarArg))
        
    }
    
    var body: some View {
        VStack{
            List{
                ForEach(purchases.wrappedValue){ item in
                    Grid(alignment: .leading){
                        GridRow{
                            Text(item.name ?? "")
                            Spacer()
                            Text("$\(item.price)")
                                .foregroundStyle(.gray)
                        }
                        Text(item.date?.formatted(.dateTime.day().month().year()) ?? "")
                            .foregroundStyle(.gray)
                            .font(.caption)
                    }
                }.onDelete(perform: { indexSet in
                    let delete = purchases.wrappedValue[indexSet.first!]
                    purchase.deletePurchase(item: delete, context: context)
                    //suma de los registros
                    total = purchases.wrappedValue.reduce(0, {$0 + $1.price})
                    resto = card.credit - total
                })
            }
            //Out of list
            Grid{
                GridRow{
                    Text("Credit: $\(card.credit)")
                        .foregroundStyle(.gray)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Text("Total: $\(total)")
                        .foregroundStyle(.gray)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Text("Rest: $\(resto)")
                        .foregroundStyle(.gray)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
            }

        }
        .navigationTitle(card.bankName ?? "No name")
        .toolbar{
            Button{
                addPurchase.toggle()
            } label:{
                Image(systemName: "plus.app").foregroundStyle(LinearGradient(colors:[.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
            }.navigationDestination(isPresented: $addPurchase){
                AddPurchaseView(card: card)
            }.onAppear{
                //suma de los registros
                total = purchases.wrappedValue.reduce(0, {$0 + $1.price})
                resto = card.credit - total
            }
        }
    }
}


