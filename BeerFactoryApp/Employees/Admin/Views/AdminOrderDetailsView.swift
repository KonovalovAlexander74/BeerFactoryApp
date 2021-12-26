//
//  AdminOrderDetailsView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.12.2021.
//

import SwiftUI

struct AdminOrderDetailsView: View {
    private var order: AdminOrder
//    @State private var canComplete = false
    @ObservedObject private var orderDetailVM = AdminOrderDetailsVM()
    
    init(order: AdminOrder) {
        self.order = order
    }
    
    var body: some View {
        ZStack {
            List {
                VStack {
                    Text("Покупатель:").font(.headline)
                    Text(order.customer).lineLimit(1)
                }
                ForEach(orderDetailVM.products, id: \.id) { product in
                    HStack {
                        Text("\(product.data.name)")
                        Spacer()
                        Text("кол-во:")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(product.data.needed)")
                            .font(.headline)
                            .foregroundColor(product.data.needed < product.data.stored ? Color.green : Color.red)
                        Text(" \\ \(product.data.stored)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            
            VStack {
                Spacer()
                HStack {
                    Button {
                        orderDetailVM.canComplete = false
                        orderDetailVM.completeOrder(order.id)
                        print("Статус заказа изменен")
                    } label: {
                        Text("Завершить")
                            .foregroundColor(.white)
                            .frame(width: 100, height: 60)
                            .background(.blue)
                            .cornerRadius(10)
                            .padding()
                            .opacity(orderDetailVM.canComplete ? 1 : 0)
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
            DispatchQueue.main.async {
                orderDetailVM.initialize(id: order.id, statusId: order.statusId)
            }
        }
        
        .navigationTitle("Детали заказа")
    }
}
//
//struct AdminOrderDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminOrderDetailsView()
//    }
//}
