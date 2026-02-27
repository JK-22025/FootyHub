//
//  Validators.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-02-26.
//

import Foundation

enum Validators{
    static func isEmailValid(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
struct SimpleError: Error{
    let message: String
    init(message: String) {
        self.message = message
    }
    var localizedDescription: String {
        return message
    } 
}
