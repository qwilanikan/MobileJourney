//
//  YourSpec.swift
//  IOSStarter
//
//  Created by Qwill Duvall on 6/14/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import Quick
import Nimble

class YourSpec: QuickSpec {
    override func spec() {
        describe("Your Spec") {
            context("when this condition is met") {
                it("should do this thing") {
                    expect(true).to(beFalse())
                }
            }
        }
    }
}
