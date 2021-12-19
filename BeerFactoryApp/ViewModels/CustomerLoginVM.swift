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
    
    func login() {
        let defaults = UserDefaults.standard
        
        WebService.login(username: username, password: password) { result in
            switch result {
            case .success(let loginResponse):
                defaults.setValue(loginResponse.token!, forKey: "userToken")
                defaults.setValue(loginResponse.user!.id, forKey: "userId")
                
                DispatchQueue.main.async {
                    self.isAuthenticated = true
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
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
}
