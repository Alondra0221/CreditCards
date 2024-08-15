//
//  AddPurchaseView.swift
//  CreditCards
//
//  Created by Alondra García Morales on 13/08/24.
//

import SwiftUI

struct AddPurchaseView: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss
    var card : Cards
    @StateObject var purchase = PurchasesViewModel()
    
    var body: some View {
        Form{
            Section("Add Purchase"){
                TextField("Name", text: $purchase.name)
                TextField("Price", text: $purchase.price)
                    .keyboardType(.decimalPad)
                Button{
                    purchase.savePurchase(context: context, card: card){ done in
                        if done{
                            //regresar a la vista enterior
                            dismiss()
                        }
                    }
                }label:{
                    Text("Save Purchase")
                        .foregroundStyle(LinearGradient(colors:[.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                }
            }
        }.navigationTitle("Add Purchase")
    }
}

