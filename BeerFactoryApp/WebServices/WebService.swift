//
//  WebService.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.11.2021.
//

import Foundation

// MARK: - Login
struct LoginRequestBody: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let message: String?
    let token: String?
    let user: User?
}

struct User: Codable {
    let id: Int
    let login: String
    let password: String
}

// MARK: - Register
struct RegisterRequestBody: Codable {
    let username: String
    let password: String
    let fullName: String
    let phoneNumber: String
    let passport: String
}

struct RegisterResponse: Codable {
    let error: Bool?
    let message: String
}

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
}
        
struct Review: Codable {
    let id: Int
    let customer: String
    let review: String
    let rate: Double
}


// MARK: - Other
enum AuthenticationError: Error {
    case invalidCredentials
    case custom(message: String)
}

class WebService {
    static private let prefixUrl = "http://localhost:3010/api"
    
    static func createNewOrder(token: String, requestBody: CreationOrderBody) {
        guard let url = URL(string: "\(prefixUrl)/create-order/") else {
            print("Not found url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {

                    let result = try JSONDecoder().decode(RegisterResponse.self, from: data)

                    DispatchQueue.main.async {
                        print(result)
                    }
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError)
            }
            
            
            print("New order created!\n")
            
        }.resume()
    }
    
    static func registerCustomer(requestBody: RegisterRequestBody, completion: @escaping (RegisterResponse) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/customer-sign-up/") else {
            print("Not found url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    
                    let result = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError)
            }
            
            
            print("Registered!\n")
            
        }.resume()
    }
    
    //MARK: - Login
    static func login(username: String, password: String, completion: @escaping (Result<LoginResponse, AuthenticationError>) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/login/") else {
            completion(.failure(.custom(message: "URL is not correct")))
            return
        }
        
        let body = LoginRequestBody(username: username, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                
                guard let data = data else {
                    completion(.failure(.custom(message: "No data")))
                    return
                }
                
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                guard let _ = loginResponse.token, let _ = loginResponse.user else {
                    completion(.failure(.invalidCredentials))
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.success(loginResponse))
                }
                
            } catch let jsonError {
                print("fetch json error: ", jsonError)
            }
        }.resume()
    }
    
    //MARK: - Get all products
    static func getProducts(token: String, completion: @escaping ([Product]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/products/") else {
            print("Not found url")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }

            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ProductData.self, from: data)

                    guard let resultData = result.data else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(resultData)
                    }
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError)
            }
        }.resume()
    }
    
    // MARK: - Get info about product
    static func getProductInfo(token: String, productId: Int, completion: @escaping (ProductInfo) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/product-info/\(productId)") else {
            print("not found url")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }

            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ProductInfo.self, from: data)

//                        print(product)
//                        print(ingredients)
//                        print(reviews)
                        
                        DispatchQueue.main.async {
                            completion(result)
                        }
                    
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError)
            }
        }.resume()
    }

    //MARK: - Get Order's products
    static func getOrderProducts(token: String, orderId: Int, completion: @escaping ([OrderProduct]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/order-products/\(orderId)") else {
            print("not found url")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }

            do {
                if let data = data {
                    let result = try JSONDecoder().decode(OrderProductData.self, from: data)

                    DispatchQueue.main.async {
                        completion(result.data)
                    }
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError)
            }
        }.resume()
    }
    
    //MARK: - Get Customer by userId
    static func getCustomer(token: String, userId: Int, completion: @escaping ([Customer]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/customer/\(userId)") else {
            print("not found url")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error", error ?? "")
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
                print("fetch json error: ", jsonError)
            }
        }.resume()
    }
    
    //MARK: - Get all Customer's orders by CustomerId
    static func getCustomerOrders(token: String, customerId: Int, completion: @escaping ([Order]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/orders/\(customerId)") else {
            print("not found url")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
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

