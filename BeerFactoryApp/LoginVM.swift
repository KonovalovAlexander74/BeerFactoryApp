//
//  LoginViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 11.12.2021.
//

import Foundation
import SwiftUI

class LoginVM: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    
    var customer: Customer?
    var employee: Employee?
    
    func loginCustomer() {
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
    
    func signOutCustomer() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userToken")
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "customerId")
        DispatchQueue.main.async {
            self.username = ""
            self.password = ""
            self.customer = nil
            self.isAuthenticated = false
        }
    }
    
    func loginEmployee() {
        let defaults = UserDefaults.standard
        
        WebService.login(username: username, password: password) { result in
            switch result {
            case .success(let loginResponse):
                defaults.setValue(loginResponse.token!, forKey: "userToken")
                defaults.setValue(loginResponse.user!.id, forKey: "userId")
                
                WebService.getEmployee(token: loginResponse.token!, userId: loginResponse.user!.id) { employees in
                    if let employee = employees.first {
                        self.employee = employee
                        defaults.setValue(employee.id, forKey: "employeeId")
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
    
    func signOutEmployee() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userToken")
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "employeeId")
        DispatchQueue.main.async {
            self.username = ""
            self.password = ""
            self.employee = nil
            self.isAuthenticated = false
        }
    }
}
