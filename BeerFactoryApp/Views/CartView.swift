//
//  CartView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 17.12.2021.
//

import SwiftUI

struct CartView: View {
//    @ObservedObject private var cartVM = CartViewModel()
    @EnvironmentObject var cartVM: CartViewModel
    
    var body: some View {
        VStack {
            List {
                //TODO: + и - count, delete
                ForEach(cartVM.elements, id: \.product.id) { item in
                    HStack {
                        VStack {
                            Text("\(item.product.name)")
                                .font(.body)
                            
                            Spacer().frame(height: 10)
                            
                            HStack {
                                Text("count: ")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text("\(item.count)")
                                    .font(.title3)
                            }
                        }.frame(width: 140, alignment: .leading)
                        
                        Spacer()
                        
                        Stepper("") {
                            item.count += 1
//                            cartVM.increment(element: item)
                            print("plus")
                        } onDecrement: {
                            print("minus")
                        }
                        
                    }
                }
            }
            .listStyle(.plain)
            .padding()
            
            Text("Total: ")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .frame(width: 300, alignment: .trailing)
            
            Spacer().frame(height: 50)
            
                .navigationTitle("Корзина")
        }
    }
}


struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
