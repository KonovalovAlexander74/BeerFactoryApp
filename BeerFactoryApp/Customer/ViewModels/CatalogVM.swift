//
//  ViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 21.11.2021.
//

import Foundation
import SwiftUI


struct ReviewBody: Codable {
    let customerId: Int
    let productId: Int
    let review: String
    let rate: Double
    let date: String
}

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
    
    func createReview(review: String, rate: Double, date: Date) {
        guard !review.isEmpty else { return }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.dateFormat = "yyyy-MM-dd"
        let formDate = formatter.string(from: .now)
        
        let defaults = UserDefaults.standard
        let customerId = defaults.integer(forKey: "customerId")
        if let token = defaults.string(forKey: "userToken") {
            let body = ReviewBody(customerId: customerId, productId: productInfo!.product.id, review: review, rate: rate, date:  formDate)
            print(body)
            WebService.createReview(token: token, requestBody: body)
            
            initialize(productId: productInfo!.product.id)
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

