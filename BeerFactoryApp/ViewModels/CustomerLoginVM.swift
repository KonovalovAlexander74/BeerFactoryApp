//
//  LoginViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 11.12.2021.
//

import Foundation

class CustomerLoginVM: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
     var customer: Customer?
    
    func login() {
        let defaults = UserDefaults.standard
        
        WebService.login(username: username, password: password) { result in
            switch result {
            case .success(let loginResponse):
                defaults.setValue(loginResponse.token!, forKey: "userToken")
                defaults.setValue(loginResponse.user!.id, forKey: "userId")
                
                WebService.getCustomer(token: loginResponse.token!, userId: loginResponse.user!.id) { customers in
                    if let customer = customers.first {
                        self.customer = customer
                        defaults.setValue(customer.id, forKey: "customerId")
                        self.isAuthenticated = true
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    func signOut() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userToken")
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "customerId")
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
}
