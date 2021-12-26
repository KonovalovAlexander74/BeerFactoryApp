//
//  File.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.12.2021.
//

import Foundation
import SwiftUI

class BuyingVM: ObservableObject {
    @Published var storedIngredients = [StoredIngredientVM]()
    @Published var ingredientsOrders = [IngredientOrderVM]()
    @Published var toBuy = [String]()
    
    init() {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken") {
            WebService.getAllStoredIngredients(token: token) { ingredients in
                self.storedIngredients = ingredients.compactMap({ StoredIngredientVM.init(data: $0) })
                self.toBuy = Array(repeating: "", count: self.storedIngredients.count)
            }
            
            WebService.getIngredientsOrders(token: token) { ingredientOrders in
                self.ingredientsOrders = ingredientOrders.compactMap({ IngredientOrderVM.init(data: $0) })
            }
        }
    }
    
    func buyIngredients(ingredientName: String, quantity: Int) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken") {
            WebService.buyIngredients(token: token, requestBody: BuyIngredientsBody(ingredientName: ingredientName, quantity: quantity))
           // TODO: Тут резко закрывается, надо как то подругому апдейтить
            WebService.getAllStoredIngredients(token: token) { ingredients in
                self.storedIngredients = ingredients.compactMap({ StoredIngredientVM.init(data: $0) })
            }
            WebService.getIngredientsOrders(token: token) { ingredientOrders in
                self.ingredientsOrders = ingredientOrders.compactMap({ IngredientOrderVM.init(data: $0) })
            }
        }
    }
}

struct IngredientOrderVM: Identifiable {
    let id = UUID()
    let data: IngredientOrder
}

struct IngredientOrder: Codable {
    let id: Int
    let storageId: Int
    let quantity: Int
    let name: String
}

struct BuyIngredientsBody: Codable {
    let ingredientName: String
    let quantity: Int
}

struct StoredIngredientVM: Identifiable {
    let id = UUID()
    let data: StoredIngredient
}
