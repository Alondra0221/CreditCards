//
//  PurchasesViewModel.swift
//  CreditCards
//
//  Created by Alondra García Morales on 13/08/24.
//

import Foundation
import CoreData

class PurchasesViewModel: ObservableObject{
    
    @Published var name = ""
    @Published var price = ""
    
    func savePurchase(context: NSManagedObjectContext, card: Cards, completion: @escaping(_ done : Bool) -> Void){
        
        let newPurchases = Purchases(context: context)
        newPurchases.id = UUID()
        newPurchases.idCard = card.id
        newPurchases.name = name
        newPurchases.price = Int16(price) ?? 0
        newPurchases.date = Date()
        
        card.mutableSetValue(forKey: "relationshipToPurchases").add(newPurchases)
        
        do{
            try context.save()
            print("Guardo la compra")
            completion(true)
        }catch let error as NSError{
            print("Fallo la compra", error.localizedDescription)
            completion(false)
        }
        
    }
    
    func deletePurchase(item: Purchases, context: NSManagedObjectContext){
        context.delete(item)
        do{
            try context.save()
            print("Eliminar compra")
            
        }catch let error as NSError{
            print("Fallo la eliminacion", error.localizedDescription)
            
        }
    }
}
