//
//  Models.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 21.11.2021.
//

import Foundation
import SwiftUI

//MARK: - Product info
struct ProductInfo: Codable {
    let error: Bool
    let message: String
    let product: Product
    let ingredients: [Ingredient]
    let reviews: [Review]
}

struct Ingredient: Codable {
    let name: String
    let quantity: Int
}
        
struct Review: Codable {
    let id: Int
    let customer: String
    let review: String
    let rate: Double
}

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

//MARK: Employee
struct EmployeeResponse: Codable {
    let error: Bool
    let message: String
    let data: Employee
}

struct Employee: Codable {
    let id: Int
    let userId: Int
    let positionId: Int
    let fullName: String
    let birthDate: String
    let phoneNumber: String
    let passport: String
    let salary: Double
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
    let message: String?
    let data: [Order]?
}

struct Order: Codable {
    let id: Int
    let status: String
}
