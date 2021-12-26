//
//  UsersVM.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.12.2021.
//

import Foundation

class UsersVM: ObservableObject {
    @Published var customers = [CustomerViewModel]()
    @Published var employees = [EmployeeViewModel]()
    
    init() {
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            WebService.getAllUsers(token: token) { employees, customers in
                self.employees = employees.compactMap({ EmployeeViewModel.init(data: $0) })
                self.customers = customers.compactMap({ CustomerViewModel.init(data: $0) })
            }
        }
    }
}

struct CustomerViewModel: Identifiable {
    let id = UUID()
    let data: Customer
}

struct EmployeeViewModel: Identifiable {
    let id = UUID()
    let data: Employee
}

struct UsersResponse: Codable {
    let error: Bool
    let message: String?
    let employees: [Employee]?
    let customers: [Customer]?
}

