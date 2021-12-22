//
//  ProductInfoView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 18.12.2021.
//

import SwiftUI

struct StarRating: View {
    @Binding var rating: Int
    
    var maximumRate = 5
    
    var offImage : Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.blue
    
    var body: some View {
        HStack {
            ForEach(1..<maximumRate + 1, id: \.self) { number in
                self.image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct TextFieldAlert: View {
    let screenSize = UIScreen.main.bounds
    
    var title: String
    @Binding var isShown: Bool
    @State var text: String = ""
    @State var rating: Int = 0
    var onDone: (String, Double) -> Void =  { _, _ in }
    
    
    var body: some View {
        VStack {
            Text(title).font(.headline)
            
            StarRating(rating: $rating)
                .padding(.vertical)
            
            TextField("", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Divider()
            
            HStack(spacing: 80) {
                
                    Button {
                        clear()
                    } label: {
                        Text("Отмена").foregroundColor(.red)
                    }
                    
                    Button {
                        onDone(self.text, Double(self.rating))
                        clear()
                    } label: {
                        Text("OK")
                    }
            }
        }
        
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.23, alignment: .center)
        .background(Color(#colorLiteral(red: 0.9333537221, green: 0.9333093762, blue: 0.9333361387, alpha: 1)))
        .cornerRadius(15)
        .shadow(color: Color(#colorLiteral(red: 0.6951510906, green: 0.6897475123, blue: 0.7073456049, alpha: 1)), radius: 3, x: -5, y: -5)
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring(), value: isShown)
    }
    
    func clear() {
        isShown = false
        text = ""
        rating = 0
    }
}


struct ProductInfoView: View { // TODO: Красиво все сделать
    private var product: ProductVM
    @ObservedObject private var productInfoVM = ProductInfoVM()
    @EnvironmentObject var cartVM: CartVM
    
    @State private var isReview = false
    @State private var reviewText = ""
    
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
                        HStack {
                            Spacer()
                            Button {
                                isReview = true
                            } label: {
                                Text("Написать отзыв").font(.headline)
                            }
                            Spacer()
                        }
                        
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
            
            TextFieldAlert(title: "Новый отзыв", isShown: $isReview) { review, rate in
                self.productInfoVM.createReview(review: review, rate: rate, date: Date.now)
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
//
//struct ProductInfoTestView: View {
//    @State private var isReview = false
//    @State private var text: String = ""
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
//                        HStack {
//                            Button {
//                                isReview = true
//                            } label: {
//                                Text("Write review")
//                            }
//
//                        }
//
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
//                        }.frame(height: 200)
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
//            }
//
//            TextFieldAlert(title: "Write Review", isShown: $isReview, text: text) { text, rate in print(text)
//            }
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
////
//struct ProductInfoView_Previews: PreviewProvider {
//    static var previews: some View {
////        ProductInfoTestView()
////        StarRating(rating: .constant(3))
//        TextFieldAlert(title: "Title", isShown: .constant(true))
//    }
//}
