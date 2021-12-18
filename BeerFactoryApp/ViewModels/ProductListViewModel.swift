//
//  ProductListViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 11.12.2021.
//

import Foundation


class ProductListViewModel: ObservableObject {
    @Published var products = [ProductVM]()
     
    func getAllProducts() {
        let defaults = UserDefaults.standard
        
        guard let token = defaults.string(forKey: "userToken") else {
            return
        }
        
        WebService.getProducts(token: token) { result in
            DispatchQueue.main.async {
                self.products = result.map(ProductVM.init)
            }
        }
    }
}


//struct ProductViewModel: Identifiable {
//    let id = UUID()
//    let product: Product
//
//    var name: String {
//        return product.name
//    }
//
//    var price: Int {
//        return product.price
//    }
//
//    init(product: Product) {
//        self.product = product
//    }
//
//    var id: Int {
//        return product.id
//    }
//
//    var name: String {
//        return product.name
//    }
//
//    var alcohol: Double {
//        return product.alcohol
//    }
//
//    var price: Int {
//        return product.price
//    }
//
//}
