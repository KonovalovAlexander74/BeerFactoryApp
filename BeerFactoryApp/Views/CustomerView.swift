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
    @ObservedObject private var customerVM = CustomerViewModel()
    
    var body: some View {
        VStack {
            
            Text("\(customerVM.fullName)")
//            Text("Струпьянов Александр Владимирович")
                .padding()
                .font(.headline)
                .lineLimit(1)
                .multilineTextAlignment(.center)
            
            ZStack {
                
                Form {
                    Text("Ваши заказы:")
                        .bold()
                        .font(.title2)
                        
                    
                    List {
                        ForEach(customerVM.orders, id: \.id) { order in
                            NavigationLink {
                                OrderDetailsView(order: order)
                            } label: {
                                HStack {
                                    Text("Заказ \(order.id)")
                                    Spacer()
                                    Text("\(order.status)")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    NavigationLink {
                        NewOrderView()
                    } label: {
                        Text("Новый заказ")
                            .font(.title).fontWeight(.bold)
                            .frame(width: 250, height: 80)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(25)
                    }
                }
                .navigationTitle("Личный кабинет")
                .toolbar {
                    NavigationLink {
                        if let customer = customerVM.customer {
                            CustomerDetailView(customer: customer)
                        }
                    } label: {
                        Image(systemName: "person")
                    }
                    
                }
            }
        }
    }
}

struct CustomerDetailView: View {
    private var customer: Customer
    
    init(customer: Customer) {
        self.customer = customer
    }
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("Имя пользователя: ")
                    Spacer()
//                    Text("\(customer.login)")
                    
                }
                HStack {
                    Text("Полное имя: ")
                    Spacer()
                    Text("\(customer.fullName)")
                    
                }
                HStack {
                    Text("Телефон: ")
                    Spacer()
                    Text("\(customer.phoneNumber)")
                }
                HStack {
                    Text("Паспорт: ")
                    Spacer()
                    Text("\(customer.passport)")
                }
            }

            Spacer()
        }
        
        .navigationTitle("Личная информация")
    }
}

struct OrderDetailsView: View {
    private var order: Order

    @ObservedObject private var orderDetailVM = OrderDetailVM()

    init(order: Order) {
        self.order = order
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(orderDetailVM.products, id: \.id) { product in
                    HStack {
                        Text("\(product.name)")
                        Spacer()
                        Text("кол-во: \(product.quantity)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            VStack {
                Spacer()
                Text("Итого: \(orderDetailVM.getTotalPrice())₽")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: 300, alignment: .trailing)
            }
        }
        
        .onAppear {
            orderDetailVM.initialize(orderId: order.id)
        }
        
        .navigationTitle("Информация о заказе")
    }
}


struct CustomerVew_Preview: PreviewProvider {
    static var previews: some View {
        CustomerView()
    }
}
