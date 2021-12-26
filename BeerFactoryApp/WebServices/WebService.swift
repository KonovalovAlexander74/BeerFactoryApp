//
//  WebService.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.11.2021.
//

import Foundation


//MARK: - Get all stored ingredients
struct StoredIngredientsResponse: Codable {
    let error: Bool
    let message: String?
    let data: [StoredIngredient]?
}

struct StoredIngredient: Codable {
    let id: Int
    let storageId: Int
    let name: String
    let quantity: Int
}

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

// MARK: - Other
enum AuthenticationError: Error {
    case invalidCredentials
    case custom(message: String)
}

class WebService {
    static private let prefixUrl = "http://localhost:3010/api"
    
    //MARK: - create New Order
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
    
    //MARK: - Register Customer
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
    
    
    //MARK: - Get all product types
    struct ProductTypesResponse: Codable {
        let error: Bool
        let message: String?
        let data: [namedString]?
    }
    
    static func getProductTypes(token: String, completion: @escaping ([String]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/all-types/") else {
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
                    let result = try JSONDecoder().decode(ProductTypesResponse.self, from: data)
                    
                    guard let resultData = result.data else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(resultData.map({ item in
                            item.name
                        }))
                    }
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError)
            }
        }.resume()
    }
    
    //MARK: - Get all ingredients
    struct IngredientsResponse: Codable {
        let error: Bool
        let message: String?
        let data: [namedString]?
    }
    
    struct namedString: Codable {
        let name: String
    }
    
    static func getAllIngredients(token: String, completion: @escaping ([String]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/all-ingredients/") else {
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
                    let result = try JSONDecoder().decode(IngredientsResponse.self, from: data)
                    
                    guard let resultData = result.data else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(resultData.map({ item in
                            item.name
                        }))
                    }
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError)
            }
        }.resume()
    }
    
    //MARK: - Get all stored ingredients
    static func getAllStoredIngredients(token: String, completion: @escaping ([StoredIngredient]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/all-stored-ingredients/") else {
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
                    let result = try JSONDecoder().decode(StoredIngredientsResponse.self, from: data)
                    
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
    
    //MARK: - Get Admin Order's products
    static func getAdminOrderProducts(token: String, orderId: Int, completion: @escaping ([AdminOrderProduct]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/admin-order-products/\(orderId)") else {
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
                    let result = try JSONDecoder().decode(AdminOrderProductResponse.self, from: data)
                    
                    if let resultData = result.data {
                        DispatchQueue.main.async {
                            completion(resultData)
                        }
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
    
    //MARK: - Get Employee by userId
    static func getEmployee(token: String, userId: Int, completion: @escaping ([Employee]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/employee/\(userId)") else {
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
                    let result = try JSONDecoder().decode(EmployeeResponse.self, from: data)
                    
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
                    
                    if let resultData = result.data {
                        DispatchQueue.main.async {
                            completion(resultData)
                        }
                    }
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError.localizedDescription)
            }
        }.resume()
    }
    
    //MARK: - Create new Review
    static func createReview(token: String, requestBody: ReviewBody) {
        guard let url = URL(string: "\(prefixUrl)/create-review/") else {
            print("not found url")
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
        }.resume()
    }
    
    //MARK: - addIngredientToRecepie
    static func addIngredientToRecepie(token: String, requestBody: AddIngredientToRecepieBody) {
        guard let url = URL(string: "\(prefixUrl)/add-recepie-ingredient/") else {
            print("not found url")
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
        }.resume()
    }
    
    //MARK: - removeIngredientFromRecepie
    static func removeIngredientFromRecepie(token: String, requestBody: AddIngredientToRecepieBody) {
        guard let url = URL(string: "\(prefixUrl)/remove-recepie-ingredient/") else {
            print("not found url")
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
        }.resume()
    }
    
    
    //MARK: - updateProductType
    static func updateProductType(token: String, requestBody: UpdateTypeBody) {
        guard let url = URL(string: "\(prefixUrl)/update-type/") else {
            print("not found url")
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
        }.resume()
    }
    
    //MARK: - updateProductPrice
    static func updateProductPrice(token: String, requestBody: UpdatePriceBody) {
        guard let url = URL(string: "\(prefixUrl)/update-price/") else {
            print("not found url")
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
        }.resume()
    }
    
    //MARK: - updateProductAlcohol
    static func updateProductAlcohol(token: String, requestBody: UpdateAlcoholBody) {
        guard let url = URL(string: "\(prefixUrl)/update-alcohol/") else {
            print("not found url")
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
        }.resume()
    }
    
    //MARK: - updateProductAlcohol
    static func updateQuantity(token: String, requestBody: UpdateQuantityBody) {
        guard let url = URL(string: "\(prefixUrl)/update-quantity/") else {
            print("not found url")
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
        }.resume()
    }
    
    //MARK: - Buy ingredients
    static func buyIngredients(token: String, requestBody: BuyIngredientsBody) {
        guard let url = URL(string: "\(prefixUrl)/buy-ingredients/") else {
            print("not found url")
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
        }.resume()
    }
    
    
    //MARK: - Get all ingredient orders
    struct IngredientOrdersResponse: Codable {
        let error: Bool
        let message: String?
        let data: [IngredientOrder]?
    }
    
    static func getIngredientsOrders(token: String, completion: @escaping ([IngredientOrder]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/ingredient-orders/") else {
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
                    let result = try JSONDecoder().decode(IngredientOrdersResponse.self, from: data)
                    
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
    
    // MARK: - getMakingProducts
    static func getMakingProducts(token: String, completion: @escaping ([MakingProduct]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/making-products/") else {
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
                    let result = try JSONDecoder().decode(MakingProductResponse.self, from: data)
                    
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
    
    
    //MARK: - Make Product
    static func makeProduct(token: String, requestBody: MakeProductBody) {
        guard let url = URL(string: "\(prefixUrl)/make-product/") else {
            print("not found url")
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
        }.resume()
    }
    
    //MARK: - pay order
    static func payOrder(token: String, orderId: Int) {
        guard let url = URL(string: "\(prefixUrl)/pay-order/\(orderId)") else {
            print("not found url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }
        }.resume()
    }
    
    //MARK: - complete order
    static func completeOrder(token: String, requestBody: CompleteOrderBody) {
        guard let url = URL(string: "\(prefixUrl)/complete-order/") else {
            print("not found url")
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
        }.resume()
    }
    
    // MARK: - Get All products for Admin
    static func getAdminOrders(token: String, completion: @escaping ([AdminOrder]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/admin-orders/") else {
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
                    let result = try JSONDecoder().decode(AdminOrderResponse.self, from: data)
                    
                    if let resultData = result.data {
                        DispatchQueue.main.async {
                            completion(resultData)
                        }
                    }
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError.localizedDescription)
            }
        }.resume()
    }
    
    //MARK: - Get all users
    static func getAllUsers(token: String, completion: @escaping ([Employee], [Customer]) -> ()) {
        guard let url = URL(string: "\(prefixUrl)/all-users/") else {
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
                    let result = try JSONDecoder().decode(UsersResponse.self, from: data)
                    
                    guard let employees = result.employees, let customers = result.customers else {
                        print("Cannot unwrap cutomers or Emlopyees")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(employees, customers)
                    }
                } else {
                    print("No data")
                }
            } catch let jsonError {
                print("fetch json error: ", jsonError)
            }
        }.resume()
    }
    
    
}

