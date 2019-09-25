//
//  AuthControllerSpec.swift
//  CarfieCoreTests
//
//  Created by Christopher Olsen on 9/25/19.
//  Copyright © 2019 espy. All rights reserved.
//

import Nimble
import Quick

@testable import CarfieCore

class AuthControllerSpec: QuickSpec {
    override func spec() {
        describe("An AuthController") {
            var subject: AuthController!

            var facebookAuthProvider: MockAuthProvider!
            var googleAuthProvider: MockAuthProvider!

            beforeEach {
                facebookAuthProvider = MockAuthProvider(type: .facebook)
                googleAuthProvider = MockAuthProvider(type: .google)
                subject = DefaultAuthController(facebookAuthProvider: facebookAuthProvider, googleAuthProvider: googleAuthProvider)
            }

            context("on login") {
                it("should set the correct auth provider on a successful login") {
                    facebookAuthProvider.loginResult = AuthResult.success(provider: .facebook)
                    subject.login(with: .facebook, andPresenter: UIViewController(nibName: nil, bundle: nil))
                    expect(subject.currentAuthProviderType).to(equal(.facebook))

                    googleAuthProvider.loginResult = AuthResult.success(provider: .google)
                    subject.login(with: .google, andPresenter: UIViewController(nibName: nil, bundle: nil))
                    expect(subject.currentAuthProviderType).to(equal(.google))
                }

                it("should not set an auth provider on a failed login") {
                    googleAuthProvider.loginResult = AuthResult.failure(error: MockAuthError.mockError)
                    subject.login(with: .google, andPresenter: UIViewController(nibName: nil, bundle: nil))
                    expect(subject.currentAuthProviderType).to(beNil())
                }
            }

            context("on logout") {
                it("should remove the current auth provider") {
                    facebookAuthProvider.logoutResult = AuthResult.success(provider: .facebook)
                    facebookAuthProvider.logout()
                    expect(subject.currentAuthProviderType).to(beNil())
                }

                it("should not allow access to a nil accessToken") {
                    facebookAuthProvider.logoutResult = AuthResult.success(provider: .facebook)
                    facebookAuthProvider.logout()
                    expect { _ = subject.currentAccessToken }.to(throwAssertion())
                }
            }

            context("current auth provider type") {
                it("should only allow setting to new values if nil") {
                    subject.currentAuthProviderType = .facebook
                    expect(subject.currentAuthProviderType).to(equal(.facebook))
                }

                it("should not allow setting to new values if it has a current value") {
                    subject.currentAuthProviderType = .facebook
                    expect { subject.currentAuthProviderType = .google }.to(throwAssertion())
                }
            }
        }
    }
}
