//
//  EmployeePersonal.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.12.2021.
//

import Foundation
import SwiftUI

struct EmployeePersonalView: View {
    @EnvironmentObject var employeeVM: EmployeePersonalVM
    @EnvironmentObject var loginVM: LoginVM
    @State private var isSignOut = false
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("Полное имя: ")
                    Spacer()
                    Text("\(employeeVM.employee?.fullName ?? "")")
                    
                }
                HStack {
                    Text("Телефон: ")
                    Spacer()
                    Text("\(employeeVM.employee?.phoneNumber ?? "")")
                }
                HStack {
                    Text("Паспорт: ")
                    Spacer()
                    Text("\(employeeVM.employee?.passport ?? "")")
                }
                HStack {
                    Text("Зарплата: ")
                    Spacer()
                    Text(String(format: "%.2f", employeeVM.employee?.salary ?? 0))
                }
            }
            
            Spacer()
            
            NavigationLink(isActive: $isSignOut) {
                LoginPageView()
            } label: {
                EmptyView()
            }
            
            Button {
                loginVM.signOutEmployee()
                isSignOut = true
            } label: {
                Text("Выйти").font(.headline).foregroundColor(.red)
            }
            
            Spacer()
        }
        
        .navigationTitle("Личная информация")
    }
}
