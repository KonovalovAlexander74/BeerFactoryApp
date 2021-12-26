//
//  AdminOrderDetailsVM.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.12.2021.
//

import Foundation

class AdminOrderDetailsVM: ObservableObject {
    @Published var canComplete = true
    @Published var products = [AdminOrderProductVM]()
    
    func initialize(id orderId: Int, statusId orderStatusId: Int) {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "userToken") else { return }
        
        WebService.getAdminOrderProducts(token: token, orderId: orderId) { products in
            self.products = products.map({ AdminOrderProductVM.init(data: $0) })
            
            var isTrue = true
            for product in self.products {
                if product.data.needed > product.data.stored {
                    isTrue = false
                    break
                }
            }
            
            self.canComplete = isTrue && orderStatusId == 1
        }
    }
    
    func getTotalPrice() -> Int {
        var sum = 0
        for product in products {
            sum += product.data.price * product.data.needed
        }
        return sum
    }
    
    func completeOrder(_ id: Int) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken") {
            WebService.completeOrder(token: token, requestBody: CompleteOrderBody(orderId: id, products: self.products.map({ $0.data })))
            initialize(id: id, statusId: 3)
        }
    }
}

struct CompleteOrderBody: Codable {
    let orderId: Int
    let products: [AdminOrderProduct]
}

struct AdminOrderProductVM: Identifiable {
    let id = UUID()
    let data: AdminOrderProduct
}

struct AdminOrderProduct: Codable {
    let name: String
    let price: Int
    let needed: Int
    let stored: Int
}

struct AdminOrderProductResponse: Codable {
    let error: Bool
    let message: String?
    let data: [AdminOrderProduct]?
}
