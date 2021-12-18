//
//  Models.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 21.11.2021.
//

import Foundation
import SwiftUI


//MARK: Product
struct ProductData: Codable {
    let error: Bool?
    let message: String?
    let data: [Product]?
}

struct Product: Codable {
    let id: Int
    let name: String
    let alcohol: Double
    let price: Int
    let type: String
}

//MARK: Order's Product
struct OrderProductData: Codable {
    let error: Bool
    let message: String
    let data: [OrderProduct]
}

struct OrderProduct: Codable {
    let id: Int
    let name: String
    let price: Int
    let quantity: Int
}

//MARK: Customer
struct CustomerData: Codable {
    let error: Bool
    let message: String
    let data: Customer
}

struct Customer: Codable {
    let id: Int
    let userId: Int
    let fullName: String
    let phoneNumber: String
    let passport: String
}

//MARK: Order
struct OrderData: Codable {
    let error: Bool
    let message: String
    let data: [Order]
}

struct Order: Codable {
    let id: Int
    let status: String
}
