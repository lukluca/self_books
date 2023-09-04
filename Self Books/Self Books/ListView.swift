//
//  ContentView.swift
//  Self Books
//
//  Created by softwave on 21/07/23.
//

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var booksModel: BooksModel
    
    var body: some View {
    
        NavigationView {
            
            switch booksModel.result {
            case .empty, .failure:
                EmptyView()
            case .inProgress:
                ProgressView()
            case .success(let books):
                List(books) { book in
                    Section(book.title) {
                        Text("Author: " + book.author)
                        Text("Title: " + book.title)
                        Text("Genre: " + book.genre.rawValue)
                        
                        NavigationLink(destination: DetailView(book: book)) {
                                            Text("Detail")
                                        }
                    }
                } //see https://sarunw.com/posts/swiftui-list-section-header-footer/ for kind of list
            }
        }
        .navigationTitle("Books")
        #if TARGET_OS_IOS
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task {
            await booksModel.reload()
        }
        .errorAlert($booksModel.error)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.allCases, id: \.self) {
            ListView()
                .environmentObject(BooksModel(network: DefaultNetwork()))
                .previewDevice($0)
        }
    }
}
