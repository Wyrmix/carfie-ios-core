//
//  FacebookAuthProvider.swift
//  CarfieCore
//
//  Created by Christopher Olsen on 9/25/19.
//  Copyright © 2019 espy. All rights reserved.
//

import Foundation
import FacebookLogin

final class FacebookAuthProvider: AuthProvider {

    let type: AuthProviderType = .facebook

    weak var delegate: AuthProviderDelegate?

    private let authManager: LoginManager

    init() {
        self.authManager = LoginManager()
    }

    func login(withPresentingViewController viewController: UIViewController) {
        authManager.logIn(permissions: [.publicProfile, .email], viewController: viewController) { [weak self] result in
            guard let sself = self else { return }

            switch result {
            case .cancelled:
                sself.delegate?.completeLogin(with: .cancel, andAccessToken: nil)
            case .failed(let error):
                sself.delegate?.completeLogin(with: .failure(error: error), andAccessToken: nil)
            case .success(_, _, let token):
                sself.delegate?.completeLogin(with: .success(provider: .facebook), andAccessToken: token.tokenString)
            }
        }
    }

    func logout() {
        authManager.logOut()
        delegate?.completeLogout(with: .success(provider: .facebook))
    }

    func getAccessToken(completion: @escaping (String?) -> Void) {
        completion(AccessToken.current?.tokenString)
    }
}
