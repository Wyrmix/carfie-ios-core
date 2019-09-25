//
//  GoogleAuthProvider.swift
//  CarfieCore
//
//  Created by Christopher Olsen on 9/25/19.
//  Copyright © 2019 espy. All rights reserved.
//

import Foundation
import GoogleSignIn

protocol GoogleAuthProvider: AuthProvider {
    func configureGoogleSignIn(with clientId: String)
    func handleGoogleAuthUrl(_ url: URL) -> Bool
}

final class DefaultGoogleAuthProvider: NSObject, GoogleAuthProvider {

    let type: AuthProviderType = .google

    weak var delegate: AuthProviderDelegate?

    private var authManager: GIDSignIn {
        return GIDSignIn.sharedInstance()
    }

    func configureGoogleSignIn(with clientId: String) {
        authManager.clientID = clientId
        authManager.delegate = self
    }

    func handleGoogleAuthUrl(_ url: URL) -> Bool {
        return authManager.handle(url)
    }

    func login(withPresentingViewController viewController: UIViewController) {
        authManager.presentingViewController = viewController

        guard authManager.hasPreviousSignIn() else {
            authManager.signIn()
            return
        }

        authManager.restorePreviousSignIn()
    }

    func logout() {
        authManager.signOut()
    }

    func getAccessToken(completion: @escaping (String?) -> Void) {
        authManager.currentUser.authentication.getTokensWithHandler { auth, error in
            guard error == nil else { return }
            completion(auth?.accessToken)
        }
    }
}

// MARK: - GIDSignInDelegate
extension DefaultGoogleAuthProvider: GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            delegate?.completeLogin(with: .failure(error: error), andAccessToken: nil)
            return
        }

        delegate?.completeLogin(with: .success(provider: .google), andAccessToken: user.authentication.accessToken)
    }

    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            delegate?.completeLogout(with: .failure(error: error))
            return
        }

        delegate?.completeLogout(with: .success(provider: .google))
    }
}

