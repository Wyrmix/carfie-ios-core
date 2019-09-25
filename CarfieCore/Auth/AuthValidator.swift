//
//  AuthValidator.swift
//  CarfieCore
//
//  Created by Christopher Olsen on 9/22/19.
//  Copyright © 2019 espy. All rights reserved.
//

import Foundation

// MARK: - Public Error Types

public enum EmailValidationError: Error {
    case noEmailEntered
    case notAValidEmail
}

public struct AuthValidator {

    // MARK: - Init

    public init() {}

    // MARK: - Public Validators

    public func validateEmail(_ email: String?) -> Result<String?> {
        guard let email = email else { return Result.failure(EmailValidationError.noEmailEntered) }

        let emailSansWhitespace = email.trimmingCharacters(in: .whitespaces)
        if isValid(email: emailSansWhitespace) {
            return Result.success(emailSansWhitespace)
        }

        return Result.failure(EmailValidationError.notAValidEmail)
    }

    // MARK: - Private Validators

     private func isValid(email: String) -> Bool{
        let emailTest = NSPredicate(format:"SELF MATCHES %@","[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: email)
    }
}
