//
//  BeerEditingTab.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 24.12.2021.
//

import SwiftUI


struct ProductEditingTab: View {
    @ObservedObject private(set) var catalogVM = CatalogVM()
    
    var body: some View {
        NavigationView {
            VStack {
                
                List(catalogVM.products) { product in
                    NavigationLink {
                        ProductEditView(product: ProductVM(product: product.product))
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
                        .frame(height: 80)
                    }
                    .listStyle(.inset)
                }
                
                .navigationTitle("Каталог")
            }
        }
    }
}

struct QuantityChanger: View {
    let startQuantity: Int
    @State private var quantity: String = ""
    var onDone: (Int) -> Void =  { _ in }
    
    var body: some View {
        TextField("", text: $quantity)
            .textFieldStyle(.roundedBorder)
            .onSubmit {
                if let num = Int(self.quantity), num < 1000 {
                    onDone(num)
                }
            }
            .onAppear {
                quantity = String(startQuantity)
            }
    }
}


struct ProductEditView: View {
    var product: ProductVM
    @ObservedObject var productEditVM = ProductEditVM()
    //    @EnvironmentObject var cartVM: CartVM
    
    @State private var isAlcohol = false
    @State private var isPrice = false
    @State private var isCount = false
    @State private var ingredient: String = ""
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                Form {
                    
                    Section("Информация") {
                        //                        MARK: - Кастомный пикер
                        //                        NavigationLink {
                        //                            SelectType(type: $type, types: $types)
                        //                        } label: {
                        //                            HStack {
                        //                                Text("Тип")
                        //                                Spacer()
                        //                                Text("\(type)")
                        //                            }
                        //
                        //                        }
                        
                        Picker("Тип", selection: $productEditVM.type) {
                            ForEach(productEditVM.types, id: \.self) { item in
                                Text(item).tag(item)
                            }
                        }.onChange(of: productEditVM.type) { type in
                            print(productEditVM.type)
                            productEditVM.updateProductType(typeName: type)
                        }
                        
                        Button {
                            isAlcohol = true
                        } label: {
                            HStack {
                                Text("Алкоголь").foregroundColor(.black)
                                Spacer()
                                Text("\(productEditVM.alcohol)").foregroundColor(.black).font(.headline)
                            }
                        }
                        
                        Button {
                            isPrice = true
                        } label: {
                            HStack {
                                Text("Цена").foregroundColor(.black)
                                Spacer()
                                Text("\(productEditVM.price)").foregroundColor(.black).font(.headline)
                            }
                        }
                    }
                    
                    Section("Рецепт") {
                        DisclosureGroup {
                            ForEach(productEditVM.ingredientNames, id: \.id) { ingr in
                                HStack {
                                    Text("\(ingr.ingredient.name)").font(.headline)
                                    
                                    QuantityChanger(startQuantity: ingr.ingredient.quantity) { res in
                                        productEditVM.updateQuantity(ingredientName: ingr.ingredient.name, quantity: res)
                                    }
                                    
//                                    Text("\(ingr.ingredient.quantity)").font(.headline).padding(.horizontal, 20)
                                    
                                    Spacer()
                                    Image(systemName: "trash").onTapGesture {
                                        if let ind = productEditVM.ingredientNames.compactMap({ $0.id }).firstIndex(of: ingr.id) {
                                            let name = productEditVM.ingredientNames.remove(at: ind).ingredient.name
                                            print(name)
                                            productEditVM.removeIngredient(ingredientName: name)
                                        }
                                    }
                                }
                            }
//                            .onDelete { indexSet in
//                                productEditVM.ingredientNames.remove(atOffsets: indexSet)
//
//                                // TODO: WebService: remove ingredient
//                            }
                            
                            Picker("Добавить", selection: $ingredient) {
                                ForEach(Array(Set(productEditVM.allIngredients)
                                                .subtracting(productEditVM.ingredientNames.compactMap({ $0.ingredient.name }))),
                                        id: \.self)
                                { ingr in
                                    Text(ingr).tag(ingr)
                                        .foregroundColor((productEditVM.ingredientNames.compactMap({ $0.ingredient.name }).contains(ingr)
                                                          ? Color.blue
                                                          : .black))
                                    
                                }
                            }
                            .onChange(of: ingredient) { _ in
                                if !productEditVM.ingredientNames.compactMap({ $0.ingredient.name }).contains(ingredient) {
                                    productEditVM.ingredientNames.append(IngredientVM(ingredient: Ingredient(name: ingredient, quantity: 0)))
                                    productEditVM.addIngredientToRecepie(ingredientName: ingredient)
                                }
                            }
                            .pickerStyle(.menu)
                        } label: {
                            Text("Рецепт")
                                .foregroundColor(.black)
                                .font(.headline)
                                .lineLimit(1)
                        }
                    }
                    
                    
                }
                .navigationBarTitle(product.name)
                
                Spacer()
            }
            
            TextFieldAlert(title: "Алкоголь", isShown: $isAlcohol, text: productEditVM.alcohol) { st in
                if let num = Double(st), num > 0, num < 30 {
                    productEditVM.updateAlcohol(alcohol: num)
                    productEditVM.alcohol = st
                }
            }
            
            TextFieldAlert(title: "Цена", isShown: $isPrice, text: productEditVM.price) { st in
                if let num = Int(st), num > 0, num < 10000 {
                    productEditVM.updatePrice(price: num)
                    productEditVM.price = st
                }
            }
        }
        .onAppear {
            productEditVM.initialize(productId: product.productId)
        }
    }
    
}
