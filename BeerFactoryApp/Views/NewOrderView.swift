//
//  NewOrderView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 26.11.2021.
//

import Foundation
import SwiftUI

struct NewOrderView: View {
    @ObservedObject private(set) var newOrderVM = NewOrderVM()
    private(set) var cartVM = CartViewModel()

    var body: some View {
        List {
            ForEach(newOrderVM.products, id: \.id) { product in
                NavigationLink {
                    ProductInfoView(product: ProductVM(product: product.product))
                        .environmentObject(cartVM)
                } label: {
                    HStack {
                        Text(product.name)
                            .padding()

                        Spacer()

                        Text("\(product.price)")
                            .padding()
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    .frame(height: 100)
                }
            }
            .listStyle(.inset)
        }
        .navigationTitle("Новый заказ")
        .toolbar {
            cartButton
        }
    }

    var cartButton: some View {
        NavigationLink {
            CartView()
                .environmentObject(cartVM)
        } label: {
            Image(systemName: "cart")
        }
    }
}

//struct NewOrderTestView: View {
//    @ObservedObject private var newOrderVM = NewOrderVM()
//
//    var body: some View {
//
//        List {
//            ForEach(0..<10, id: \.self) { item in
//                NavigationLink {
//
//                    ProductInfoTestView()
//                } label: {
//                    HStack {
//                        Text("Товар \(item)")
//                            .padding()
//
//                        Spacer()
//
//                        Text("Price - 50")
//                            .padding()
//                            .foregroundColor(.gray)
//                            .font(.caption)
//                    }
//                    .frame(height: 100)
//                }
//
//
//            }
//            .listStyle(.inset)
//        }
//        //TODO: Сделать меню создание заказа
//        .navigationBarTitle("Новый заказ")
//        .toolbar {
//            cartButton
//        }
//
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

struct NewOrderView_Previews: PreviewProvider {
    static var previews: some View {
        NewOrderView()
    }
}
