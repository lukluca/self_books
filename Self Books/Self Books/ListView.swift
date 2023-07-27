//
//  ContentView.swift
//  Self Books
//
//  Created by softwave on 21/07/23.
//

import SwiftUI

enum Genre: String {
    case poetry
    case drama
    case noir
    case novel
}

struct Book: Identifiable {
    let id = UUID()
    let isbn: String
    let title: String
    let author: String
    let genre: Genre
    let url: URL
}

func makeBooks() -> [Book] {
    
    let howl = "https://m.media-amazon.com/images/I/41rGq6gqNdL._SX198_BO1,204,203,200_QL40_ML2_.jpg"
    let bomb = "https://i0.wp.com/auralcrave.com/wp-content/uploads/2018/01/C9YfIRPW0AA4z4A.jpeg?w=700&ssl=1"
    let prove = "https://www.ibs.it/images/9788890543494_0_536_0_75.jpg"
    let nera = "https://www.oscarmondadori.it/content/uploads/2020/11/978880472570HIG.JPG"
    
    let infos = ["Allen Ginsberg" : ("Howl", howl, Genre.poetry),
                 "Gregory Corso" : ("Bomb", bomb, Genre.poetry),
                 "Dario Bertini" : ("Prove di nuoto nella birra scura", prove, Genre.poetry) ,
                 "Dino Buzzati" : ("La nera", nera, Genre.noir)]
    
    return (0...12).compactMap { _ -> Book? in
        
        let isbn = (0...13).reduce("") { acc, next in
            acc + "\(Int.random(in: 0..<10))"
        }
        
        let (author, title, image, genre) = infos.enumerated().map{($1.key, $1.value.0, $1.value.1, $1.value.2)}[Int.random(in: 0..<infos.count)]
        
        guard let url = URL(string: image) else {
            return nil
        }
        
        return Book(
            isbn: isbn,
            title: title,
            author: author,
            genre: genre,
            url: url
        )
    }
}

struct ListView: View {
    
    @State private var books = [Book]()
    
    @State private var isProgressViewHidden = false
    
    var body: some View {
    
        NavigationView {
            ZStack {
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
                
                ProgressView().isHidden(isProgressViewHidden)
            }
        }
        .navigationTitle("Books")
        #if TARGET_OS_IOS
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task {
            do {
                try await Task.sleep(nanoseconds: 3_500_000_000)
                isProgressViewHidden = true
                books = makeBooks()
            } catch {
                books = []
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.allCases, id: \.self) {
            Tab()
                .previewDevice($0)
        }
    }
}

struct DetailView: View {
    
    let book: Book
    
    var body: some View {
        VStack {
            Text("Author: " + book.author)
            Text("Title: " + book.title)
            Text("Genre: " + book.genre.rawValue)
            Text("ISBN: " + book.isbn)
            AsyncImage(url: book.url) { image in image.resizable() } placeholder: { Color.red } .frame(width: 128, height: 128) .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
}
