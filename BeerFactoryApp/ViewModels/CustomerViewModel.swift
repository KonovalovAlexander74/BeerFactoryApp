//
//  CustomerViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.11.2021.
//

import Foundation
import SwiftUI


class CustomerViewModel: ObservableObject {
    @Published var customer: Customer?
    @Published var orders = [Order]()
    
    init() {
        let defaults = UserDefaults.standard
        
        let id = defaults.integer(forKey: "userId")
        
        guard let token = defaults.string(forKey: "userToken") else {
            return
        }
        
        WebService.getCustomer(token: token, userId: id) { customers in
            if let customer = customers.first {
                self.customer = customer
                
                WebService.getCustomerOrders(token: token, customerId: customer.id) { orders in
                    self.orders = orders
                }
            }
        }
    }
    
    var id: Int {
        guard let customer = customer else { return 1 }
        return customer.id
    }
    
    var fullName: String {
        guard let customer = customer else { return "" }

        return customer.fullName
    }
}

