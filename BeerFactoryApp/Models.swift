//
//  Models.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 21.11.2021.
//

import Foundation
import SwiftUI


//MARK: Product
struct ProductData: Decodable {
    let error: Bool
    let message: String
    let data: [Product]
}

struct Product: Decodable {
    let id: Int
    let typeId: Int
    let name: String
    let alcohol: Float
    let price: Int
}

//MARK: Customer
struct CustomerData: Decodable {
    let error: Bool
    let message: String
    let data: Customer
}

struct Customer: Decodable {
    let id: Int
    let userId: Int
    let fullName: String
    let phoneNumber: String
    let passport: String
    let login: String
    let password: String
}

//MARK: Order
struct OrderData: Decodable {
    let error: Bool
    let message: String
    let data: [Order]
}

struct Order: Decodable {
    let id: Int
    let status: String
}


