//
//  ProductInfoView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 18.12.2021.
//

import SwiftUI


struct ProductInfoView: View { // TODO: Красиво все сделать
    private var product: ProductVM
    @ObservedObject private var productInfoVM = ProductInfoVM()
    @EnvironmentObject var cartVM: CartVM
    
    init(product: ProductVM) {
        self.product = product
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                
                Form {
                    Section("Информация") {
                        myText(lhs: "Тип: ", rhs: "\(productInfoVM.productInfo?.product.type ?? "")")
                        myText(lhs: "Алкоголь: ", rhs: "\(productInfoVM.productInfo?.product.alcohol ?? 0)")
                        myText(lhs: "Цена: ", rhs: "\(productInfoVM.productInfo?.product.price ?? 0)")
                    }
                    
                    Section("Состав") {
                        ForEach(productInfoVM.ingredients, id: \.name) { ingredient in
                            Text("\(ingredient.name)")
                        }
                    }
                    
                    Section("Отзывы") {
                        ScrollView {
                            ForEach(productInfoVM.reviews, id: \.id) { review in
                                HStack {
                                    Spacer()
                                    VStack {
                                        Text(review.customer).font(.title3).frame(alignment: .leading).lineLimit(1)
                                        Text(review.review).font(.body)
                                    }
                                    Spacer()
                                }
                                Divider()
                            }
                        }.frame(height: 300)
                    }
                }
                
                .navigationBarTitle("Детали")
                
                
                Spacer()
            }
            
            VStack() {
                Spacer()
                
                Button {
                    cartVM.addProduct(product: ProductVM(product: self.product.product))
                } label: {
                    Text("В корзину").font(.title).bold()
                }.frame(width: 200, height: 60, alignment: .center)
                    .background(.blue)
                    .cornerRadius(20)
                    .padding()
                    .foregroundColor(.white)
            }
            
        }
        .onAppear {
            productInfoVM.initialize(productId: product.productId)
        }
        
    }
    
    func myText(lhs: String, rhs: String) -> some View {
        return HStack {
            Text(lhs)
                .font(.title2)
            Spacer()
            Text(rhs)
                .font(.title3)
                .padding(.trailing, 30)
        }
    }
}

//struct ProductInfoTestView: View { // TODO: Красиво все сделать
//    var body: some View {
//        ZStack {
//
//            VStack {
//
//                Form {
//                    Section("Details") {
//                        myText(lhs: "Type: ", rhs: "Пиво")
//                        myText(lhs: "Alcohol: ", rhs: "5.5%")
//                        myText(lhs: "Price: ", rhs: "120")
//                    }
//
//                    Section("Ingredients") {
//                        ForEach(0..<4, id: \.self) { ingr in
//                            Text("\(ingr)")
//                        }
//                    }
//
//                    Section("Reviews") {
//                        ScrollView {
//                            ForEach(0..<10) { _ in
//                                HStack {
//                                    Spacer()
//                                    VStack {
//                                        Text("Customer").font(.title2).frame(alignment: .leading)
//                                        Text("Review").font(.body)
//                                    }
//                                    Spacer()
//                                }
//                                Divider()
//                            }
//                        }.frame(height: 300)
//                    }
//                }
//
//                .navigationBarTitle("Название")
//
//
//                Spacer()
//            }
//
//            VStack {
//                Spacer()
//                Button {
//
//                } label: {
//                    Text("Add to cart").font(.title).bold()
//                }
//                .frame(width: 200, height: 60, alignment: .center)
//                .background(.blue)
//                .cornerRadius(20)
//                .foregroundColor(.white)
//
//
//            }
//
//        }
//
//    }
//
//    func myText(lhs: String, rhs: String) -> some View {
//        return HStack {
//            Text(lhs)
//                .font(.title2)
//            Spacer()
//            Text(rhs)
//                .font(.title3)
//                .padding(.trailing, 30)
//        }
//    }
//}
//
//struct ProductInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductInfoTestView()
//    }
//}
