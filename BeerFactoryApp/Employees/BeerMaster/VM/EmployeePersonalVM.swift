//
//  EmployeePersonalVM.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.12.2021.
//

import Foundation
import SwiftUI

class EmployeePersonalVM: ObservableObject {
    @Published var employee: Employee?
    
    init(employee: Employee?) {
        self.employee = employee
    }
    
    var id: Int {
        guard let employee = employee else { return 1 }
        return employee.id
    }
    
    var fullName: String {
        guard let employee = employee else { return "" }
        return employee.fullName
    }
}
