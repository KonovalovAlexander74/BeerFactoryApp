//
//  ConsumerView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.11.2021.
//

import Foundation
import SwiftUI
import Alamofire

struct OrdersView: View {
    @EnvironmentObject var ordersVM: OrdersVM
    
    var body: some View {
        NavigationView {
            VStack {
                
                List(ordersVM.orders) { orderVM in
                    NavigationLink {
                        OrderDetailsView(order: orderVM.order)
                    } label: {
                        HStack {
                            Text("Заказ \(orderVM.order.id)")
                            Spacer()
                            Text("\(orderVM.order.status)")
                                .font(.caption)
                        }
                        
                    }
                    
                }
                .refreshable {
                    self.ordersVM.fetchOrders()
                }
                
                .navigationTitle("Заказы")
            }
            .onAppear {
                self.ordersVM.fetchOrders()
            }
        }
    }
}

struct OrderDetailsView: View {
    private var order: Order
    @State private var isPayed = false
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
                HStack {
                        Button {
                            isPayed = true
                            orderDetailVM.payOrder(order.id)
                            print("Статус заказа изменен")
                        } label: {
                            Text("Оплатить")
                                .foregroundColor(.white)
                                .frame(width: 100, height: 60)
                                .background(.blue)
                                .cornerRadius(10)
                                .padding()
                                .opacity(isPayed ? 0 : 1)
                        }
                    
                    Text("Итого: \(orderDetailVM.getTotalPrice())₽")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(width: 200, alignment: .trailing)
                        .padding()
                        
                }
            }
            
        }
        
        .onAppear {
            orderDetailVM.initialize(orderId: order.id)
            isPayed = order.status == "Оплачен" || order.status == "Завершен"
        }
        
        .navigationTitle("Детали заказа")
    }
}


struct CustomerVew_Preview: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
