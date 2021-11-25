//
//  WebService.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.11.2021.
//

import Foundation
import Alamofire

class WebService {
    private let prefixUrl = "http://localhost:3000"
    
    //MARK: - Get Products
    func getProducts(completion: @escaping ([Product]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/products") else {
            print("not found url")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }

            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ProductData.self, from: data)

                    DispatchQueue.main.async {
                        completion(result.data)
                    }
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError.localizedDescription)
            }
        }.resume()
    }
    
    //MARK: - Get Customer by login and password
    func getCustomer(login: String, password: String, completion: @escaping ([Customer]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/user/\(login)/\(password)") else {
            print("not found url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(CustomerData.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion([result.data])
                    }
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError.localizedDescription)
            }
        }.resume()
    }
    
    //MARK: - Get Order by CustomerId
    func getOrders(customerId: Int, completion: @escaping ([Order]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/orders/\(customerId)") else {
            print("not found url")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }

            do {
                if let data = data {
                    let result = try JSONDecoder().decode(OrderData.self, from: data)

                    DispatchQueue.main.async {
                        completion(result.data)
                    }
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError.localizedDescription)
            }
        }.resume()
    }
    
}

