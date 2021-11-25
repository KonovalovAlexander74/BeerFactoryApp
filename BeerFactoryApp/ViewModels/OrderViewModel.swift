//
//  OrderViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.11.2021.
//


import Foundation
import SwiftUI

class OrderListViewModel: ObservableObject {
    @Published var orders = [OrderViewModel]()
    
    init(customerId: Int) {
        WebService().getOrders(customerId: customerId) { orders in
            self.orders = orders.map(OrderViewModel.init)
        }
    }
}

class OrderViewModel {
    var order: Order
    
    init(order: Order) {
        self.order = order
    }
    
    var id: Int {
        return order.id
    }
    
    var status: String {
        return order.status
    }
}

