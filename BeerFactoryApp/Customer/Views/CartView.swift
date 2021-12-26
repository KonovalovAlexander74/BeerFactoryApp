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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
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
                                        
                                        TextField("", text: Binding(
                                            get: { String(item.quantity) },
                                            set: {
                                                cartVM.setQuantity(element: item, newQuantity: Int($0) ?? 1)
                                            }
                                        )).keyboardType(.numberPad).focused($isFocused)
                                    }
                                }.frame(width: 140, alignment: .leading)
                                
                                Text("цена: \(item.product.price)")
                                    .font(.caption)
                                
                                Spacer()
                                
                                Stepper("") {
                                    cartVM.increment(element: item)
                                } onDecrement: {
                                    cartVM.decrement(element: item)
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
                            Text("создать заказ")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 140, height: 50)
                                .background(.blue)
                                .cornerRadius(20)
                                .padding()
                                .opacity(cartVM.elements.isEmpty ? 0 : 1)
                        }
                        
                        Spacer()
                        Text("Итого: \(cartVM.total)")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.trailing)
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
                
                if isFocused {
                    VStack {
                        Spacer()
                        Button {
                            isFocused = false
                        } label: {
                            Text("Готово").font(.headline)
                        }
                        Spacer()
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
