//
//  CalculatorButton.swift
//  TDDCalculator
//
//  Created by Qwill Duvall on 6/28/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import Foundation

enum CalculatorButton {
    case number(Double)
    case operation(String)
    case variable(String)
    
}

extension CalculatorButton: Equatable {
    
    static func ==(lhs: CalculatorButton, rhs: CalculatorButton) -> Bool {
        switch (lhs, rhs) {
                    case (.number(let a), .number(let b)):
                        return a == b
                    case (.variable(let a), .variable(let b)):
                        return a == b
                    case (.operation(let a), .operation(let b)):
                    return a == b
        default: return false
        }
    }
}

