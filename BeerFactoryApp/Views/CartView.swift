//
//  CartView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 17.12.2021.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartVM: CartVM
    @EnvironmentObject var ordersVM: OrdersVM
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(cartVM.elements, id: \.product.id) { item in
                        HStack {
                            VStack(spacing: 8) {
                                Text("\(item.product.name)")
                                    .font(.body)
                                
                                HStack {
                                    Text("кол-во: ")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(item.quantity)")
                                        .font(.headline)
                                }
                            }.frame(width: 140, alignment: .leading)
                            
                            Text("цена: \(item.product.price)")
                                .font(.caption)
                            
                            Spacer()
                            
                            Stepper("") {
                                cartVM.increment(element: item)
                                //                            print("plus")
                            } onDecrement: {
                                cartVM.decrement(element: item)
                                //                            print("minus")
                            }
                            
                        }
                    }
                }
                .listStyle(.plain)
                .padding()
                
                HStack {
                    Button {
                        cartVM.createOrder()
                    } label: {
                        Text("создать")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .background(.blue)
                            .cornerRadius(20)
                            .padding()
                    }
                    
                    Spacer()
                    Text("Итого: \(cartVM.total)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                }
                
                
                .navigationTitle("Корзина")
                .toolbar {
                    Button {
                        cartVM.clear()
                    } label: {
                        Image(systemName: "trash")
                    }
                    
                }
                
            }
        }
    }
}


struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
