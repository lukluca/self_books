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
}

func makeBooks() -> [Book] {
    
    let infos = ["Allen Ginsberg" : ("Howl", Genre.poetry), "Gregory Corso" : ("Bomb", Genre.poetry), "Dario Bertini" : ("Prove di nuoto nella birra scura", Genre.poetry) , "Dino Buzzati" : ("La nera", Genre.noir)]
    
    return (0...12).map { _ -> Book in
        
        let isbn = (0...13).reduce("") { acc, next in
            acc + "\(Int.random(in: 0..<10))"
        }
        
        let (author, title, genre) = infos.enumerated().map{($1.key, $1.value.0, $1.value.1)}[Int.random(in: 0..<infos.count)]
        
        return Book(
            isbn: isbn,
            title: title,
            author: author,
            genre: genre
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
                        Text("ISBN: " + book.isbn)
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
                try await Task.sleep(nanoseconds: 5_500_000_000)
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
