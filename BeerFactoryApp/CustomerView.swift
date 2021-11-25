//
//  ConsumerView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.11.2021.
//

import Foundation
import SwiftUI
import Alamofire

struct CustomerView: View {
    @State private var selection = 0
    @ObservedObject private var customerVM = CustomerViewModel()
//    @ObservedObject private var ordersVM = OrderListViewModel(customerId: customerVM.id)
    
    var body: some View {
        VStack {
            
            Text("Вы вошли как \n\(customerVM.fullName)")
                .frame(height: 80)
            
            ZStack {
                
                Form {
                    List {
//                        ForEach(ordersVM.orders, id: \.id) { item in
                        ForEach(0..<5, id: \.self) { item in
                            Picker("Заказ \(item)", selection: $selection) {
//                                OrderDetailsView(number: "\(item)")
                            }
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    NavigationLink {
//                        NewOrderView()
                        Text("")
                    } label: {
                        Text("Новый заказ")
                            .font(.title).fontWeight(.bold)
                            .frame(width: 250, height: 80)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(25)
                    }
                }
                .navigationTitle("Ваши заказы")
            }
        }
    }
}
//
//struct OrderDetailsView: View {
//    private var number: String
//
//    init(number: String) {
//        self.number = number
//    }
//
//    var body: some View {
//        Text("Информация о заказе")
//        Spacer()
//
//            .navigationTitle("Заказ \(number)")
//    }
//}
//
//struct NewOrderView: View {
//    var body: some View {
//        ProductsView()
//        //TODO: Сделать меню создание заказа
//            .navigationTitle("Новый заказ")
//            .toolbar {
//                cartButton
//            }
//    }
//
//    var cartButton: some View {
//        NavigationLink {
//            CartView()
//        } label: {
//            Image(systemName: "cart")
//        }
//    }
//}
//
//struct CartView: View {
//    var body: some View {
//        VStack {
//            List {
//                //TODO: + и - count, delete
//                ForEach(0..<8, id: \.self) { item in
//                    HStack {
//                        VStack {
//                            Text("Товар \(item)")
//                                .font(.title2)
//
//                            Spacer().frame(height: 10)
//
//                            HStack {
//                                Text("count: ")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//
//                                Text("7")
//                                    .font(.title3)
//                            }
//                        }.frame(width: 140, alignment: .leading)
//
//                        Spacer()
//
//                        Stepper("") {
//                            print("plus")
//                        } onDecrement: {
//                            print("minus")
//                        }
//
//                    }
//                }
//            }
//            .listStyle(.plain)
//            .padding()
//
//            //            Spacer()
//
//            Text("Total: ")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding()
//                .frame(width: 300, alignment: .trailing)
//
//            Spacer().frame(height: 50)
//
//                .navigationTitle("Корзина")
//        }
//    }
//}

struct ConsumerView_Previews: PreviewProvider {
    static var previews: some View {
//        CartView()
        CustomerView()
    }
}
