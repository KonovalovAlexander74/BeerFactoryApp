//
//  CustomerViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.11.2021.
//

import Foundation
import SwiftUI


class CustomerViewModel: ObservableObject {
    @Published var customer: Customer!
    
    init() {
        WebService().getCustomer(login: "dmitry01", password: "password") { customers in
            if let customer = customers.first {
                self.customer = customer
            }
        }
    }
    
    var id: Int {
        return customer.id
    }
    
    var fullName: String {
        return customer.fullName
    }
}

