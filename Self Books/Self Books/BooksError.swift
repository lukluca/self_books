//
//  Error.swift
//  Self Books
//
//  Created by softwave on 02/09/23.
//

import SwiftUI

//https://stackoverflow.com/a/75189683

struct BooksError: LocalizedError {
    
    let error: Error
    
    var errorDescription: String? {
        "Male!" //this is the title
    }
    
    var errorMessage: String {
        "Male male!"
    }
}

struct ErrorAlert: ViewModifier {
    
    @Binding var error: BooksError?
    var isShowingError: Binding<Bool> {
        Binding {
            error != nil
        } set: { _ in
            error = nil
        }
    }
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: isShowingError, error: error) { _ in
            } message: { error in
                Text(error.errorMessage)
            }
    }
}

extension View {
    func errorAlert(_ error: Binding<BooksError?>) -> some View {
        self.modifier(ErrorAlert(error: error))
    }
}
