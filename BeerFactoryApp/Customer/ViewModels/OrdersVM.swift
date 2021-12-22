//
//  OrdersVM.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.11.2021.
//

import Foundation
import SwiftUI

struct OrderVM: Identifiable {
    let id = UUID()
    let order: Order
}

class OrdersVM: ObservableObject {
    @Published var orders = [OrderVM]()
    
    init() {
        fetchOrders()
    }
    
    public func fetchOrders() {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken") {
            let customerId = defaults.integer(forKey: "customerId")
            WebService.getCustomerOrders(token: token, customerId: customerId) { orders in
                self.orders = orders.compactMap({ return OrderVM(order: $0) })
            }
        }
    }
}

