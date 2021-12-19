//
//  ViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 21.11.2021.
//

import Foundation
import SwiftUI

class ProductInfoVM: ObservableObject {
    @Published var productInfo: ProductInfo?
    
    func initialize(productId: Int) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken") {
            WebService.getProductInfo(token: token, productId: productId) { info in
                self.productInfo = info;
            }
        }
    }
    
    var ingredients: [Ingredient] {
        guard let productInfo = productInfo else {
            return []
        }
        
        return productInfo.ingredients
    }
    
    var reviews: [Review] {
        guard let productInfo = productInfo else {
            return []
        }
        
        return productInfo.reviews
    }
}

class CatalogVM: ObservableObject {
    @Published var products = [ProductVM]()
    
    init() {
        let defaults = UserDefaults.standard
        
        if let token = defaults.string(forKey: "userToken") {
            WebService.getProducts(token: token) { products in
                self.products = products.map(ProductVM.init)
            }
        }
    }
}

class ProductVM: Identifiable {
    var id = UUID()
    var product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    var productId: Int {
        return product.id
    }
    
    var name: String {
        return product.name
    }
    
    var alcohol: Double {
        return product.alcohol
    }
    
    var price: Int {
        return product.price
    }
    
}

