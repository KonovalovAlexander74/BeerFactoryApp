//
//  RegisterViewModel.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 12.12.2021.
//

import Foundation


class CustomerRegisterVM: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var passport: String = ""
    
    @Published var message: String = ""
    
    @Published var isAlert: Bool = false
    
    func register() {
        let requestBody = RegisterRequestBody(username: username,
                                              password: password,
                                              fullName: fullName,
                                              phoneNumber: phoneNumber,
                                              passport: passport)
        
        WebService.registerCustomer(requestBody: requestBody) { response in
            DispatchQueue.main.async {
                self.message = response.message
                self.isAlert = !self.isAlert
            }
            print(response.message)
        }
    }
    
}
