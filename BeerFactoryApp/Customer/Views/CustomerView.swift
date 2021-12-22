//
//  CustomerView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 19.12.2021.
//

import SwiftUI

enum CustomerTab: Int {
    case orders = 0
    case cart = 1
    case catalog = 2
    case personal = 3
    
    var rawValues: [Int] {
        [0, 1, 2, 3]
    }
}

struct CustomerView: View {
    let names = ["house", "cart", "list.bullet", "person"]
    @State var currentTab: CustomerTab = .orders
    
    var body: some View {
        VStack(spacing: 0) {
            switch currentTab {
            case .orders:
                OrdersView()
            case .cart:
                CartView()
            case .catalog:
                CatalogView()
            case .personal:
                PersonalView()
            }
            
            //            Spacer()
            Divider()
            HStack {
                ForEach(currentTab.rawValues, id: \.self) { rawId in
                    Button {
                        switch rawId {
                        case 0:
                            currentTab = .orders
                        case 1:
                            currentTab = .cart
                        case 2:
                            currentTab = .catalog
                        case 3:
                            currentTab = .personal
                        default:
                            currentTab = .orders
                        }
                    } label: {
                        Spacer()
                        Image(systemName: names[rawId])
                            .foregroundColor(currentTab.rawValue == rawId ? .black : .gray)
                            .font(.system(size: 25))
                            .padding()
                        Spacer()
                    }
                    
                    
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView()
    }
}
