//
//  ContentView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 21.11.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LoginPageView()
    }
}

struct LoginPageView: View {
    @State var login: String = ""
    @State var password: String = ""
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                Spacer().frame(height: 100)
                
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
                    TextField("Логин", text: $login)
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
                    
                    SecureField("Пароль", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                
                Spacer().frame(height: 70)
                
                if (!login.isEmpty && !password.isEmpty) {
                    NavigationLink {
                        CustomerView()
                    } label: {
                        Text("Войти")
                            .frame(width: 120, height: 60)
                            .background(.blue)
                            .cornerRadius(20)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Пивной завод")
        }
    }
}

//
//struct ProductsView: View {
//    @ObservedObject private var productViewModel = ProductListViewModel()
//
//    var body: some View {
//        VStack {
//
//
//            List {
////                    ForEach(viewModel.items, id: \.id) { item in
//                ForEach(0..<10, id: \.self) { item in
//
//                        HStack {
//                            Text("item.name")
//                                .padding()
//
//                            Spacer()
//
//                            Text("цена: item.price")
//                                .padding()
//                                .foregroundColor(.gray)
//                                .font(.caption)
//                        }.frame(height: 100)
//                    }.listStyle(.inset)
//                }
//
//            .navigationTitle("Товары")
//        }
//    }
//
//
//}
//

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
//            ProductsView()
        }
    }
}
