//
//  deleteCardView.swift
//  CreditCards
//
//  Created by Alondra García Morales on 13/08/24.
//

import SwiftUI

struct deleteCardView: View {
    
    @Environment(\.managedObjectContext) private var context
    @StateObject var cards : CardsViewModel
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            VStack(spacing: 20){
                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                    .padding(.top, 20)
                                
                Text("Delete Card")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                                
                Text("Do you really want to delete this card?")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Button{
                    cards.deleteCard(item: cards.updateItem, context: context)
                } label: {
                    Text("Delete")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .frame(width: 300)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.9), Color.red]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .cornerRadius(25)
                        .shadow(radius: 10)
                        .padding(.horizontal, 40)
                        .transition(.slide)
                       
        }.onDisappear{
            cards.updateItem = nil 
        }
    }
}


