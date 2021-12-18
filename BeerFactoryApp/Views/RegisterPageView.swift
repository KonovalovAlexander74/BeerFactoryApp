//
//  RegisterPageView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 12.12.2021.
//

import SwiftUI

struct RegisterPageView: View {
    @StateObject private var registerVM = RegisterViewModel()
    
    var body: some View {
        let titles = ["Имя пользователя", "Пароль", "ФИО", "Телефон", "Паспорт"]
        
        let bindings = [$registerVM.username, $registerVM.password, $registerVM.fullName, $registerVM.phoneNumber, $registerVM.passport]
        
        
        VStack {
            
            ZStack{
                Form {
                    VStack(spacing: 20) {
                        ForEach(titles.indices) { index in
                            VStack(spacing: 15) {
                                HStack {
                                    Text(titles[index])
                                        .frame(alignment: .leading)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    Spacer()
                                }
                                
                                TextField(titles[index], text: bindings[index])
                                    .textFieldStyle(.plain)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20))
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                            }
                        }
                        
                    }
                }
                
                VStack {
                    Spacer()
                    
                    Button {
                        registerVM.register()
                    } label: {
                        Text("Зарегестироваться")
                            .font(Font.system(size: 20))
                            .bold()
                            .frame(width: 200, height: 90)
                            .background(.blue)
                            .cornerRadius(20)
                            .foregroundColor(.white)
                    }.alert(registerVM.message, isPresented: $registerVM.isAlert) {}
                    
                    Spacer().frame(height: 50)
                }
                
            }
        }
        
        .navigationTitle("Регистрация")
    }
}

struct RegisterPageView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPageView()
    }
}
