//
//  OrderViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.11.2021.
//


import Foundation
import SwiftUI

class OrderDetailVM: ObservableObject {
    @Published var products = [OrderProductVM]()
    
    func initialize(orderId: Int) {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "userToken") else { return }
        
        WebService.getOrderProducts(token: token, orderId: orderId) { products in
            self.products = products.map(OrderProductVM.init)
        }
    }
    
    func getTotalPrice() -> Int {
        var sum = 0
        
        for product in products {
            sum += product.price * product.quantity
        }
        
        return sum
    }
    
    func payOrder(_ id: Int) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken") {
            WebService.payOrder(token: token, orderId: id)
            initialize(orderId: id)
        }
    }
}

class OrderProductVM {
    var product: OrderProduct
    
    init(product: OrderProduct) {
        self.product = product
    }
    
    var id: Int {
        return product.id
    }

    var name: String {
        return product.name
    }

    var quantity: Int {
        return product.quantity
    }
    
    var price: Int {
        return product.price
    }
}
