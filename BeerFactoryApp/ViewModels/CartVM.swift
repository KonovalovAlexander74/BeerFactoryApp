//
//  CartViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 18.12.2021.
//

import Foundation
import SwiftUI

class CartElementVM: ObservableObject, Identifiable {
    var id = UUID()
    var product: ProductVM
    var quantity: Int
    
    init(product: ProductVM) {
        self.product = product
        self.quantity = 1
    }
}

class CartVM: ObservableObject {
    @Published var total: Int = 0
    @Published var elements = [CartElementVM]()
    
    func addProduct(product: ProductVM) {
        elements.append(CartElementVM(product: product))
        total += product.price
    }
    
    func increment(element: CartElementVM) {
        element.quantity += 1
        total += element.product.price
    }
    
    func setQuantity(element: CartElementVM, newQuantity: Int) {
        guard (newQuantity < 1000) else { return }
        element.quantity = newQuantity
        total = element.product.price * newQuantity
    }
    
    func decrement(element: CartElementVM) {
        if (element.quantity > 0) {
            element.quantity -= 1
            total -= element.product.price
        }
        
        if element.quantity == 0, let index = elements.firstIndex(where: {$0.id == element.id}) {
            elements.remove(at: index)
        }
    }
    
    func clear() {
        elements.removeAll()
        total = 0
    }
    
    func createOrder() {
        print("Created Order")
        guard !elements.isEmpty else { return }
        
        var products = [CreateOrderProduct]()
        for element in elements {
            products.append(CreateOrderProduct(productId: element.product.productId, quantity: element.quantity))
        }
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "userToken") else { return }
        let customerId = defaults.integer(forKey: "customerId")
        
        let body = CreationOrderBody(customerId: customerId, products: products)
        
        WebService.createNewOrder(token: token, requestBody: body)
        
        clear()
    }
}

struct CreationOrderBody: Codable {
    let customerId: Int
    let products: [CreateOrderProduct]
}

struct CreateOrderProduct: Codable {
    let productId: Int
    let quantity: Int
}
