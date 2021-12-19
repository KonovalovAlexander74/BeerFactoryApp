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
        }
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
        
        .navigationTitle("Детали заказа")
    }
}


struct CustomerVew_Preview: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
