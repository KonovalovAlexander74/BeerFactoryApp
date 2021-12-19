//
//  NewOrderView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 26.11.2021.
//

import Foundation
import SwiftUI

struct CatalogView: View {
    @ObservedObject private(set) var catalogVM = CatalogVM()
    
    var body: some View {
        NavigationView {
            VStack {
                
                List(catalogVM.products) { product in
                    NavigationLink {
                        ProductInfoView(product: ProductVM(product: product.product))
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
                    .listStyle(.inset)
                }
                
                .navigationTitle("Каталог")
            }
        }
    }
    
    //    var cartButton: some View {
    //        NavigationLink {
    //            CartView()
    //                .environmentObject(cartVM)
    //        } label: {
    //            Image(systemName: "cart")
    //        }
    //    }
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
        CatalogView()
    }
}
