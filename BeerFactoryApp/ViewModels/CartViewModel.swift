//
//  CartViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 18.12.2021.
//

import Foundation
import SwiftUI

class CartElement {
    var product: ProductVM
    var count: Int
    
    init(product: ProductVM) {
        self.product = product
        self.count = 1
    }
    
    func increment() {
        self.count += 1
    }
}

class CartViewModel: ObservableObject {
    @Published var total: Int = 0
    @Published var elements = [CartElement]()
    
    func addProduct(product: ProductVM) {// TODO:
        elements.append(CartElement(product: product))
    }
    
    func increment(element: CartElement) {
        element.increment()
    }
    
    func createOrder() {
        print("Created Order")
    }
}

