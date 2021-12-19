//
//  ContentView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 21.11.2021.
//

import SwiftUI

struct LoginPageView: View {
    @StateObject private var loginVM = CustomerLoginVM()
    
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
                    
                    Spacer().frame(height: 60)
                    
                    Text("Авторизация")
                        .foregroundColor(.gray)
                        .padding()
                    
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
                    
                    Spacer().frame(height: 70)
                    
                    Button {
                        loginVM.isAuthenticated ? loginVM.signOut() : loginVM.login()
                    } label: {
                        Text(loginVM.isAuthenticated ? "Выйти" : "Войти")
                            .frame(width: 120, height: 60)
                            .background(.blue)
                            .cornerRadius(20)
                            .foregroundColor(.white)
                    }
                    
                    
                    if (loginVM.isAuthenticated) {
                        NavigationLink {
                            CustomerView()
                        } label: {
                            Text("Личный кабинет")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
    }
}
