//
//  DetailView.swift
//  Self Books
//
//  Created by softwave on 02/09/23.
//

import SwiftUI


struct DetailView: View {
    
    let book: Book
    
    @State private var isRead = false // SwiftUI manages the property’s storage. When the value changes, SwiftUI updates the parts of the view hierarchy that depend on the value.
    
    //TODO show how to pass through binding data to list view
    
    var body: some View {
        VStack {
            Text("Author: " + book.author)
            Text("Title: " + book.title)
            Text("Genre: " + book.genre.rawValue)
            Text("ISBN: " + book.isbn)
            AsyncImage(url: book.url) { image in image.resizable() } placeholder: { Color.red } .frame(width: 128, height: 128) .clipShape(RoundedRectangle(cornerRadius: 25))
            
            HStack(alignment: .center) {
                Spacer(minLength: 150)
                Toggle("Read", isOn: $isRead)
                Spacer(minLength: 150)
            }.padding(.top, 10)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let book = Book(isbn: "", title: "", author: "", genre: .drama, url: URL(string: "www.google.com")!)
        
        ForEach(Device.allCases, id: \.self) {
            DetailView(book: book)
                .previewDevice($0)
        }
    }
}
