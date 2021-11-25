//
//  ViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 21.11.2021.
//

import Foundation
import SwiftUI

class ProductListViewModel: ObservableObject {
    @Published var products = [ProductViewModel]()
    
    init() {
        WebService().getProducts { products in
            self.products = products.map(ProductViewModel.init)
        }
    }
}

class ProductViewModel {
    var product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    var id: Int {
        return product.id
    }
    
    var name: String {
        return product.name
    }
    
    var alcohol: Float {
        return product.alcohol
    }
    
    var price: Int {
        return product.price
    }
    
}

