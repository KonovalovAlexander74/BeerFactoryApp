//
//  BeerMasterView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 23.12.2021.
//

import SwiftUI

struct TextFieldAlert: View {
    let screenSize = UIScreen.main.bounds
    
    var title: String
    @Binding var isShown: Bool
    @State var text: String = ""
    var onDone: (String) -> Void =  { _ in }
    
    
    var body: some View {
        VStack {
            Text(title).font(.headline)
            
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
                    onDone(self.text)
                    clear()
                } label: {
                    Text("OK")
                }
            }
        }
        
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.20, alignment: .center)
        .background(Color(#colorLiteral(red: 0.9333537221, green: 0.9333093762, blue: 0.9333361387, alpha: 1)))
        .cornerRadius(15)
        .shadow(color: Color(#colorLiteral(red: 0.6951510906, green: 0.6897475123, blue: 0.7073456049, alpha: 1)), radius: 3, x: -5, y: -5)
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring(), value: isShown)
    }
    
    func clear() {
        isShown = false
        text = ""
    }
}

enum BeerMasterTab: Int {
    case editing = 0
    case creatig = 1
    case buy = 2
    case personal = 3
    
    var rawValues: [Int] {
        [0, 1, 2, 3]
    }
}

struct BeerMasterView: View {
    @State var currentTab: BeerMasterTab = .editing
    private let names = ["list.bullet.rectangle", "beer", "cart", "person"]
    
    var body: some View {
        VStack(spacing: 0) {
            switch currentTab {
            case .editing:
                ProductEditingTab()
            case .creatig:
                MakingBeerView()
            case .buy:
                BeerBuying()
            case .personal:
                EmployeePersonalView()
            }
            
            Divider()
            HStack {
                ForEach(currentTab.rawValues, id: \.self) { rawId in
                    Button {
                        switch rawId {
                        case 0:
                            currentTab = .editing
                        case 1:
                            currentTab = .creatig
                        case 2:
                            currentTab = .buy
                        case 3:
                            currentTab = .personal
                        default:
                            currentTab = .editing
                        }
                    } label: {
                        Spacer()
                        
                        if rawId == 1 {
                            Image(currentTab.rawValue == rawId ? "beer" : "beer-gray")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .scaledToFit()
                        } else {
                            Image(systemName: names[rawId])
                                .foregroundColor(currentTab.rawValue == rawId ? .black : .gray)
                                .font(.system(size: 25))
                                .padding()
                        }
                        
                        
                        Spacer()
                    }
                    
                    
                }
            }
        }
        .navigationBarHidden(true)
    }
}


struct BeerMasterView_Previews: PreviewProvider {
    static var previews: some View {
        BeerMasterView()
    }
}


struct SelectType: View {
    @Binding var type: String
    @Binding var types: [String]
    @State private var isAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    ForEach(types, id: \.self) { item in
                        HStack { // TODO: Нажатие на всю облать, а не на текст
                            Text(item).tag(item)
                            Spacer()
                            if (type == item) { Image(systemName: "checkmark") }
                        }.onTapGesture {
                            type = item
                        }
                    }
                    //                    .onDelete { indexSet in
                    //                        types.remove(atOffsets: indexSet)
                    //                    }
                    
                    
                    Button {
                        isAlert = true
                    } label: {
                        Text("Новый тип")
                    }
                    
                    HStack {
                        Button {
                            isAlert = true
                        } label: {
                            Text("Новый тип")
                        }
                        
                        Button {
                            isAlert = true
                        } label: {
                            Text("Новый тип")
                        }
                    }
                }
                
                //                Spacer()
            }
            TextFieldAlert(title: "Новый тип", isShown: $isAlert, text: type) { st in
                if (!st.isEmpty) {
                    types.append(st)
                }
                //TODO: Webservice Post and Get
            }
        }
    }
}


// MARK: - Отзывы для админа
//Section("Отзывы") {
//    DisclosureGroup {
//        ForEach(reviews, id: \.self) { review in
//            HStack {
//                Spacer()
//                VStack {
//                    Text("Customer").font(.title2).frame(alignment: .leading)
//                    Text(review).font(.body)
//                }
//                Spacer()
//            }
//        }
//        .onDelete { indexSet in
//            reviews.remove(atOffsets: indexSet)
//        }
//    } label: {
//        Text("Отзывы")
//    }
//}
