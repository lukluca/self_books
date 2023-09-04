//
//  Models.swift
//  Self Books
//
//  Created by softwave on 02/09/23.
//

import Foundation
import SwiftUI
import Combine

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

@MainActor
class BooksModel: ObservableObject { //By default an ObservableObject synthesizes an objectWillChange publisher that emits the changed value before any of its @Published properties changes.
    
    let network: Network
    @Published var result: AsyncResult<[Book]> = .empty //When the property changes, publishing occurs in the property's `willSet` block, meaning subscribers receive the new value before it's actually set on the property
    
    @Published var error: BooksError?
    
    private var bag = Set<AnyCancellable>()
    
    init(network: Network) {
        self.network = network
        
        $result.map { value -> BooksError? in
            if case let .failure(error) = value {
                return BooksError(error: error)
            }
            return nil
        }.sink { [weak self] error in
            self?.error = error
        }.store(in: &bag)
    }
    
    func reload() async {
        result = .inProgress
        do {
            result = .success(try await network.books())
        } catch {
            result = .failure(error)
        }
    }
}
