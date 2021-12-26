//
//  ProductEditingVM.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.12.2021.
//

import Foundation

struct ProductEditInfo: Codable {
    var error: Bool
    var message: String
    var product: Product
    var ingredients: [Ingredient]
    var reviews: [Review]
}

struct IngredientEdit: Codable {
    var name: String
    var quantity: Int
}

class ProductEditVM: ObservableObject {
    private var productId: Int?
    @Published var productInfo: ProductInfo?
    
    @Published var types = [String]()
    @Published var allIngredients = [String]()
    @Published var ingredientNames = [IngredientVM]()
    
    @Published var name: String = ""
    @Published var alcohol: String = ""
    @Published var price: String = ""
    @Published var type: String = ""
    
    func addIngredientToRecepie(ingredientName: String) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken"), let id = productId {
            WebService.addIngredientToRecepie(token: token, requestBody: AddIngredientToRecepieBody(productId: id, ingredientName: ingredientName))
        }
    }
    
    func removeIngredient(ingredientName: String) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken"), let id = productId {
            WebService.removeIngredientFromRecepie(token: token, requestBody: AddIngredientToRecepieBody(productId: id, ingredientName: ingredientName))
        }
    }
    
    func updateProductType(typeName: String) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken"), let id = productId {
            WebService.updateProductType(token: token, requestBody: UpdateTypeBody(productId: id, typeName: typeName))
        }
    }
    
    func updateQuantity(ingredientName: String, quantity: Int) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken"), let id = productId {
            WebService.updateQuantity(token: token, requestBody: UpdateQuantityBody(productId: id, ingredientName: ingredientName, quantity: quantity))
        }
    }
    
    func updateAlcohol(alcohol: Double) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken"), let id = productId {
            WebService.updateProductAlcohol(token: token, requestBody: UpdateAlcoholBody(productId: id, alcohol: alcohol))
        }
    }
    
    func updatePrice(price: Int) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken"), let id = productId {
            
            WebService.updateProductPrice(token: token, requestBody: UpdatePriceBody(productId: id, price: price))
        }
    }
    
    func initialize(productId: Int) {
        self.productId = productId
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken") {
            WebService.getProductInfo(token: token, productId: productId) { info in
                self.productInfo = info
                
                if self.name.isEmpty{ self.name = info.product.name }
            
                if self.alcohol.isEmpty{ self.alcohol = String(info.product.alcohol) }
                    
                if self.price.isEmpty{ self.price = String(info.product.price) }
                
                if self.type.isEmpty{ self.type = info.product.type }
                
                self.ingredientNames = info.ingredients.map({ ing in
                    IngredientVM(ingredient: Ingredient(name: ing.name, quantity: ing.quantity))
                })
            }
            
            WebService.getProductTypes(token: token) { types in
                self.types = types
            }
            
            WebService.getAllIngredients(token: token) { ingredients in
                self.allIngredients = ingredients
            }
            
        }
    }
    
//    var ingredients: [IngredientVM] {
//        guard let productInfo = productInfo else {
//            return []
//        }
//        
//        return productInfo.ingredients.compactMap({ return IngredientVM(ingredient: $0) })
//    }
}

struct IngredientVM: Identifiable {
    let id = UUID()
    let ingredient: Ingredient
}

struct AddIngredientToRecepieBody: Codable {
    let productId: Int
    let ingredientName: String
}

struct UpdateTypeBody: Codable {
    let productId: Int
    let typeName: String
}

struct UpdateAlcoholBody: Codable {
    let productId: Int
    let alcohol: Double
}

struct UpdatePriceBody: Codable {
    let productId: Int
    let price: Int
}

struct UpdateQuantityBody: Codable {
    let productId: Int
    let ingredientName: String
    let quantity: Int
}

