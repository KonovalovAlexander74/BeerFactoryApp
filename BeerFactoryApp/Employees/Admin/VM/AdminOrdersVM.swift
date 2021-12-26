//
//  File.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.12.2021.
//

import Foundation

class AnminOrdersVM: ObservableObject {
    @Published var orders = [AdminOrderVM]()
    
    func fetchOrders() {
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            WebService.getAdminOrders(token: token) { orders in
                self.orders = orders.compactMap({ AdminOrderVM.init(data: $0) })
            }
        }
    }
    
    init() {
        fetchOrders()
    }
}

struct AdminOrderVM: Identifiable {
    let id = UUID()
    let data: AdminOrder
}

struct AdminOrder: Codable {
    let id: Int
    let statusId: Int
    let customer: String
    let status: String
}

struct AdminOrderResponse: Codable {
    let error: Bool
    let message: String?
    let data: [AdminOrder]?
}
