//
//  EmployeesListView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.12.2021.
//

import SwiftUI

struct UsersListView: View {
    @ObservedObject private var usersVM = UsersVM()
    
    var body: some View {
        Form {
            Text("Тут должен быть список всех пользователей(Сотрудники + Покупатели и возможность их редактировать)").multilineTextAlignment(.center)
        }
//        if !usersVM.employees.isEmpty {
//            ForEach(usersVM.employees, id: \.id) { emp in
//                Text(emp.data.fullName)
//            }
//        }
        
//        Form {
//            Section("Сотрудники") {
//                ForEach(usersVM.employees, id: \.id) { emp in
//                    Text(emp.data.fullName)
//                }
//            }
//
//            Section("Покупатели") {
//                ForEach(usersVM.customers, id: \.id) { cust in
//                    Text(cust.data.fullName)
//                }
//            }
//        }
    }
}

struct EmployeesListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
