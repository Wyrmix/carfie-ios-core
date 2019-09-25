//
//  MockAuthProvider.swift
//  CarfieCoreTests
//
//  Created by Christopher Olsen on 9/25/19.
//  Copyright © 2019 espy. All rights reserved.
//

@testable import CarfieCore

enum MockAuthError: Error {
    case mockError
}

class MockAuthProvider: AuthProvider {
    var type: AuthProviderType

    weak var delegate: AuthProviderDelegate?

    var loginResult: AuthResult?
    var logoutResult: AuthResult?
    var accessToken: String?

    init(type: AuthProviderType) {
        self.type = type
    }

    func login(withPresentingViewController viewController: UIViewController) {
        guard let loginResult = loginResult else { return }
        delegate?.completeLogin(with: loginResult, andAccessToken: accessToken)
    }

    func logout() {
        guard let logoutResult = logoutResult else { return }
        delegate?.completeLogout(with: logoutResult)
    }

    func getAccessToken(completion: @escaping (String?) -> Void) {
        completion(accessToken)
    }
}

extension MockAuthProvider: GoogleAuthProvider {
    func configureGoogleSignIn(with clientId: String) {}

    func handleGoogleAuthUrl(_ url: URL) -> Bool {
        return false
    }
}
