//
//  Network.swift
//  Self Books
//
//  Created by softwave on 02/09/23.
//

import Foundation

// https://www.ralfebert.com/ios-app-development/swiftui/asyncview/

enum AsyncResult<Success> {
    case empty
    case inProgress
    case success(Success)
    case failure(Error)
}

protocol Network {
    func books() async throws -> [Book]
}


struct DefaultNetwork: Network {
    func books() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 3_500_000_000)
        return makeBooks()
    }
}

struct ErrorNetwork: Network {
    
    struct RandomError: Error {}
    
    func books() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 3_500_000_000)
        throw RandomError()
    }
}

private extension DefaultNetwork {
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
}
