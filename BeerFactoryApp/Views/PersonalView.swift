//
//  PersonalTabView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 19.12.2021.
//

import SwiftUI


struct PersonalView: View {
    @EnvironmentObject var customerVM: CustomerVM
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("Полное имя: ")
                    Spacer()
                    Text("\(customerVM.customer?.fullName ?? "")")
                    
                }
                HStack {
                    Text("Телефон: ")
                    Spacer()
                    Text("\(customerVM.customer?.phoneNumber ?? "")")
                }
                HStack {
                    Text("Паспорт: ")
                    Spacer()
                    Text("\(customerVM.customer?.passport ?? "")")
                }
            }
            
            Spacer()
        }
        
        .navigationTitle("Личная информация")
    }
}

//struct PersonalTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonalView()
//    }
//}
