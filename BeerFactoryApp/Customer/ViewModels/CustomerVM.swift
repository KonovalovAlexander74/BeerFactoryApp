//
//  CustomerVM.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 19.12.2021.
//

import Foundation
import SwiftUI

class CustomerVM: ObservableObject {
    @Published var customer: Customer?
    
    init(customer: Customer?) {
//        let defaults = UserDefaults.standard
//
//        let id = defaults.integer(forKey: "userId")
//        guard let token = defaults.string(forKey: "userToken") else {
//            return
//        }
//
//        WebService.getCustomer(token: token, userId: id) { customers in
//            if let customer = customers.first {
//                self.customer = customer
//                defaults.setValue(customer.id, forKey: "customerId")
//            }
//        }
        
        self.customer = customer
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
