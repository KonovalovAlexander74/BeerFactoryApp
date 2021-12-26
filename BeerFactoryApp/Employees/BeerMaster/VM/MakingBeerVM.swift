//
//  NewProductVM.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.12.2021.
//

import Foundation
import SwiftUI

class MakingBeerVM: ObservableObject {
    @Published var products = [MakingProductVM]()
    @Published var toMake = [String]()
    
    init() {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken") {
            WebService.getMakingProducts(token: token) { makingProducts in
                self.products = makingProducts.compactMap({ MakingProductVM.init(data: $0) })
                self.toMake = Array(repeating: "", count: self.products.count)
            }
        }
    }
    
    func makeProduct(_ name: String, quantity: Int) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "userToken") {
            WebService.makeProduct(token: token, requestBody: MakeProductBody(name: name, quantity: quantity))
        }
    }
    
    func refresh() {
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            WebService.getMakingProducts(token: token) { makingProducts in
                self.products = makingProducts.compactMap({ MakingProductVM.init(data: $0) })
                self.toMake = Array(repeating: "", count: self.products.count)
            }
        }
    }
}

struct MakeProductBody: Codable {
    let name: String
    let quantity: Int
}

struct MakingProductVM: Identifiable {
    let id = UUID()
    let data: MakingProduct
}

struct MakingProduct: Codable {
    let name: String
    let available: Int
    let stored: Int
}

struct MakingProductResponse: Codable {
    let error: Bool
    let message: String?
    let data: [MakingProduct]?
}
