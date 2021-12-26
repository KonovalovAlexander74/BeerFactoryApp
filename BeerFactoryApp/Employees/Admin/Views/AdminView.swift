//
//  AdmitView.swift
//  BeerFactoryApp
//
//  Created by Alexander Konovalov on 25.12.2021.
//

import SwiftUI


enum AdminTab: Int {
    case orders = 0
    case employees = 1
    case personal = 2
    
    var rawValues: [Int] {
        [0, 1, 2]
    }
}

struct AdminView: View {
    @State var currentTab: AdminTab = .orders
    private let names = ["list.bullet.rectangle", "person.3.sequence", "person"]
    
    var body: some View {
        VStack(spacing: 0) {
            switch currentTab {
            case .orders:
                AdminOrdersView()
            case .employees:
                UsersListView()
            case .personal:
                EmployeePersonalView()
            }
            
            Divider()
            HStack {
                ForEach(currentTab.rawValues, id: \.self) { rawId in
                    Button {
                        switch rawId {
                        case 0:
                            currentTab = .orders
                        case 1:
                            currentTab = .employees
                        case 2:
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


struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
