//
//  AdminOrdersView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.12.2021.
//

import SwiftUI

struct AdminOrdersView: View {
    @ObservedObject private var ordersVM = AnminOrdersVM()
    
    var body: some View {
        Form {
            Section("Оплаченные") {
                List(ordersVM.orders.filter({ $0.data.statusId == 1 }), id: \.id) { order in
                    NavigationLink {
                        AdminOrderDetailsView(order: order.data)
                    } label: {
                        HStack {
                            Text("Заказ \(order.data.id)")
                            Spacer()
                            Text("\(order.data.status)")
                                .font(.caption)
                        }
                    }
                }
            }
            
            Section("Созданные") {
                DisclosureGroup("Заказы") {
                    List(ordersVM.orders.filter({ $0.data.statusId == 2 }), id: \.id) { order in
                        NavigationLink {
                            AdminOrderDetailsView(order: order.data)
                        } label: {
                            HStack {
                                Text("Заказ \(order.data.id)")
                                Spacer()
                                Text("\(order.data.status)")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            
            Section("Завершенные") {
                DisclosureGroup("Заказы") {
                    List(ordersVM.orders.filter({ $0.data.statusId == 3 }), id: \.id) { order in
                        NavigationLink {
                            AdminOrderDetailsView(order: order.data)
                        } label: {
                            HStack {
                                Text("Заказ \(order.data.id)")
                                Spacer()
                                Text("\(order.data.status)")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            
        }
        .refreshable {
            self.ordersVM.fetchOrders()
        }
    }
}

struct AdminOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        AdminOrdersView()
    }
}
