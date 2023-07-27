//
//  Tab.swift
//  Self Books
//
//  Created by softwave on 21/07/23.
//

import SwiftUI

struct Tab: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Label("Books", systemImage: "list.dash")
                }
            ContentView()
                .tabItem {
                    Label("Add", systemImage: "plus")
                }
        }
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        Tab()
            .previewDisplayName("Mac")
        
        Tab()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
            .previewDisplayName("iPhone 14 Pro Max")
    }
}

struct ContentView: View {
    var body: some View {
        Text("Add func")
    }
}
