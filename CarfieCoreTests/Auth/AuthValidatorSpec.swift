//
//  AuthValidatorSpec.swift
//  CarfieCoreTests
//
//  Created by Christopher Olsen on 9/25/19.
//  Copyright © 2019 espy. All rights reserved.
//

import Nimble
import Quick

@testable import CarfieCore

class AuthValidatorSpec: QuickSpec {
    override func spec() {
        describe("An AuthValidator") {
            var subject: AuthValidator!

            beforeEach {
                subject = AuthValidator()
            }

            context("email validation") {
                it("with an empty email should throw an error") {
                    expect { try subject.validateEmail(nil).resolve() }.to(throwError(EmailValidationError.noEmailEntered))
                }

                it("with no '@' should throw an error") {
                    expect { try subject.validateEmail("emailemail.com").resolve() }.to(throwError(EmailValidationError.notAValidEmail))
                }

                it("with no '.' should throw an error") {
                    expect { try subject.validateEmail("email@email").resolve() }.to(throwError(EmailValidationError.notAValidEmail))
                }

                it("with proper formatting should pass validation") {
                    expect { try subject.validateEmail("email@email.io").resolve() }.to(equal("email@email.io"))
                }
            }
        }
    }
}
