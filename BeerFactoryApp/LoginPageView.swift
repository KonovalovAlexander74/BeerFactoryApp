//
//  ContentView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 21.11.2021.
//

import SwiftUI

enum LoginedUser: String, CaseIterable, Identifiable {
    case customer
    case employee
    
    var id: String { self.rawValue }
}

struct LoginPageView: View {
    @EnvironmentObject var loginVM: LoginVM
//        @State var loginedUser: Int = 0
    @State private var loginedUser = LoginedUser.customer
    
    var body: some View {
        NavigationView {
            
            Group {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: loginVM.isAuthenticated
                              ? "lock.fill"
                              : "lock.open")
                            .padding()
                    }
                    
                    Picker(selection: $loginedUser) {
                        Text("Покупатель").tag(LoginedUser.customer)
                        Text("Работник").tag(LoginedUser.employee)
                    } label: {
                        Text("Войти как")
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    Text("Авторизация")
                        .foregroundColor(.gray)
                        .padding()
                    
                    logPasTextFields
                    
                    registerButton
                        .opacity(loginedUser == .customer ? 1 : 0)
                    
                    Spacer().frame(height: 70)
                    
                    if (loginVM.isAuthenticated) {
                        NavigationLink {
                            switch loginedUser {
                            case .customer:
                                CustomerView()
                                    .environmentObject(CustomerVM(customer: self.loginVM.customer ?? nil))
                                    .environmentObject(CartVM())
                                    .environmentObject(OrdersVM())
                            case .employee:
                                if let emp = loginVM.employee {
                                    switch emp.positionId {
                                    case 1:
                                        AdminView()
                                            .environmentObject(EmployeePersonalVM(employee: self.loginVM.employee ?? nil))
                                    case 2:
                                        BeerMasterView()
                                            .environmentObject(EmployeePersonalVM(employee: self.loginVM.employee ?? nil))
                                    default:
                                        Text("Unknown employee")
                                    }
                                }
                            }
                        } label: {
                            Text("Личный кабинет")
                                .frame(width: 120, height: 60)
                                .background(.blue)
                                .cornerRadius(20)
                                .foregroundColor(.white)
                        }
                    } else {
                        Button {
                            switch loginedUser {
                            case .customer:
                                loginVM.loginCustomer()
                            case .employee:
                                loginVM.loginEmployee()
                            }
                        } label: {
                            Text("Войти")
                                .frame(width: 120, height: 60)
                                .background(.blue)
                                .cornerRadius(20)
                                .foregroundColor(.white)
                        }
                    }
                    
                }
            }
            .navigationTitle("Вход")
        }
        
    }
    
    var registerButton: some View {
        HStack {
            Spacer()
            
            NavigationLink {
                RegisterPageView()
            } label: {
                Text("Регистрация")
                    .frame(width: 120, height: 20)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
    }
    
    
    var logPasTextFields: some View {
        VStack {
            VStack {
                HStack {
                    Text("Логин")
                        .frame(alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                    Spacer()
                }
                TextField("Логин", text: $loginVM.username)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
            
            Spacer().frame(height: 30)
            
            VStack {
                HStack {
                    Text("Пароль")
                        .frame(alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                    Spacer()
                }
                
                SecureField("Пароль", text: $loginVM.password)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
    }
}
