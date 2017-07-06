//
//  CalculatorBrain.swift
//  TDDCalculator
//
//  Created by Qwill Duvall on 6/26/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    var description: String {
        get {
            let (_, _, description) = evaluate(using: nil)
            return description
        }
    }
    
    var resultIsPending: Bool {
        get {
            let (_, isPending, _) = evaluate(using: nil)
            return isPending
        }
    }
    
    var result: Double? {
        get {
            let (result, _, _) = evaluate(using: nil)
            return result
        }
    }
    
    var sequenceOfOperationsAndOperands: Array<CalculatorButton> = []
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double)->Double)
        case binaryOperation((Double, Double)->Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "abs": Operation.unaryOperation(abs),
        "±" : Operation.unaryOperation({-$0}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "^": Operation.binaryOperation({pow($0, $1)}),
        "×" : Operation.binaryOperation({$0 * $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "=" : Operation.equals
    ]
    
    mutating func setOperand(_ operand: Double){
        sequenceOfOperationsAndOperands.append(CalculatorButton.number(operand))
    }
    
    mutating func setOperand(_ operand: String){
        sequenceOfOperationsAndOperands.append(CalculatorButton.variable(operand))
    }
    
    mutating func setOperation(_ operation: String){
        sequenceOfOperationsAndOperands.append(CalculatorButton.operation(operation))
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    
    func createDescription(using variables: Dictionary<String,Double>? = nil)
        -> String {
            var description = ""
            var accumulator: Double?
            
            for button in sequenceOfOperationsAndOperands {
                switch button {
                case .number(let operand):
                    accumulator = operand
                    
                case .variable(let variable):
                    description = variable
                    
                case .operation(let symbol):
                    if let operation = operations[symbol] {
                        switch operation {
                        case .constant:
                            description = symbol
                        case .unaryOperation:
                            if accumulator != nil {
                                description = "\(symbol)(\(accumulator!))"

                            }
                        case .binaryOperation:
                            description = ""
                        case .equals:
                            description = ""
                        }
                    }
                }
            }
            return description
    }




    func evaluate(using variables: Dictionary<String,Double>? = nil)
        ->(result: Double?, isPending: Bool, description: String){
            var result: Double?
            var pendingBinaryOperation: PendingBinaryOperation?
            var resultIsPending = false
            var description = ""
            
            func performPendingBinaryOperation() {
                if pendingBinaryOperation != nil && result != nil {
                    result = pendingBinaryOperation!.perform(with: result!)
                    pendingBinaryOperation = nil
                    resultIsPending = false
                }
            }
            
            for button in sequenceOfOperationsAndOperands {
                switch button {
                case .number(let operand):
                    result = operand
                case .variable(let variable):
                    result = 0.0
                    if let variables = variables {
                        if let variable = variables[variable] {
                            result = variable
                        }
                    }
                case .operation(let symbol):
                    if let operation = operations[symbol] {
                        switch operation {
                        case .constant(let value):
                            result = value
                        case .unaryOperation(let function):
                            if result != nil {
                                result = function(result!)
                            }
                        case .binaryOperation(let function):
                            if result != nil {
                                pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: result!)
                                result = nil
                                resultIsPending = true
                            }
                        case .equals:
                            if result != nil {
                                performPendingBinaryOperation()
                            }
                        }
                    }
                }
            }
            
            description = createDescription(using: variables)
            
            return (result, resultIsPending, description)
    }
    
}
