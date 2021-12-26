//
//  BeerNewProduct.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.12.2021.
//

import SwiftUI

struct MakingBeerView: View {
    @ObservedObject private var makingBeerVM = MakingBeerVM()
    
    var body: some View {
//        Form {
            List(makingBeerVM.products, id: \.id) { product in
                getElement(for: product)
            }.refreshable {
                self.makingBeerVM.refresh()
            }
//        }
    }
    
    func getElement(for product: MakingProductVM) -> some View {
        return DisclosureGroup("\(product.data.name)") {
            HStack {
                Text("В наличии")
                Spacer()
                Text("\(product.data.stored)").bold()
            }
            
            HStack {
                Text("Можно приготовить")
                Spacer()
                Text("\(product.data.available)").bold()
            }
            
            
            HStack {
                if let ind = makingBeerVM.products.map({ $0.id }).firstIndex(of: product.id) {
                    TextField("", text: $makingBeerVM.toMake[ind])
                        .textFieldStyle(.roundedBorder)
                    
                    Spacer()
                    
                    Button {
                        if let quantity = Int(makingBeerVM.toMake[ind]), quantity > 0 {
                            //                                print("Приготовил \(quantity)")
                            makingBeerVM.makeProduct(product.data.name, quantity: quantity)
                            makingBeerVM.toMake[ind] = ""
                        }
                    } label: {
                        Text("Приготовить").foregroundColor(.white).bold().font(.title3)
                            .frame(width: 160, height: 30)
                            .background(.blue)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

//struct BeerNewProduct_Previews: PreviewProvider {
//    static var previews: some View {
//        BeerNewProduct()
//    }
//}
