//
//  BeerBuying.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.12.2021.
//

import SwiftUI

struct BeerBuying: View {
    @ObservedObject private var buyingVM = BuyingVM()
    
    var body: some View {
        Form {
            Section("Склады") {
                List(buyingVM.storedIngredients, id: \.id) { ingr in
                    getElement(for: ingr)
                }
            }
            
            Section("Заказы ингредиентов") {
                ForEach(buyingVM.ingredientsOrders, id: \.id) { order in
                    DisclosureGroup("Заказ \(order.data.id)  -  \(order.data.name)") {
                        HStack {
                            Text("Склад ")
                            Text("\(order.data.storageId)").bold()
                            
                            Spacer()
                            
                            Text("кол-во ").font(.caption).foregroundColor(.gray)
                            Text("\(order.data.quantity)").bold()
                        }
                    }
                }
            }
        }
    }
    
    func getElement(for ingr: StoredIngredientVM) -> some View {
        return DisclosureGroup("\(ingr.data.name)") {
            HStack {
                Text("Склад ")
                Text("\(ingr.data.storageId)").bold()
                
                Spacer()
                
                Text("кол-во ").font(.caption).foregroundColor(.gray)
                Text("\(ingr.data.quantity)").bold()
            }
            
            
            HStack {
                if let ind = buyingVM.storedIngredients.map({ $0.id }).firstIndex(of: ingr.id) {
                    TextField("", text: $buyingVM.toBuy[ind])
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            print(buyingVM.toBuy[ind])
                        }
                    
                    
                    Spacer()
                    
                    Button {
                        if let quantity = Int(buyingVM.toBuy[ind]), quantity > 0 {
                            print("Байнул \(quantity)")
                            buyingVM.buyIngredients(ingredientName: ingr.data.name, quantity: quantity)
                            buyingVM.toBuy[ind] = ""
                        }
                    } label: {
                        Text("Купить").foregroundColor(.white).bold().font(.title3)
                            .frame(width: 100, height: 30)
                            .background(.blue)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct BeerBuying_Previews: PreviewProvider {
    static var previews: some View {
        BeerBuying()
    }
}
