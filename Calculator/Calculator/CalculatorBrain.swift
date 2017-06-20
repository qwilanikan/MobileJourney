//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Qwill Duvall on 6/7/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var sequenceOfOperationsAndOperands: Array<CalculatorButton> = []
    
    var result: Double? {
        get {
            let (result, _, _) = evaluate(using: nil)
            return result
        }
    }
    
    var resultIsPending: Bool {
        get {
            let (_, isPending, _) = evaluate(using: nil)
            return isPending
        }
    }
    
    var description: String {
        get {
            let (_, _, description) = evaluate(using: nil)
            return description
        }
    }
    
    private enum CalculatorButton {
        case Operation(String)
        case variable(String)
        case number(Double)
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double)->Double)
        case binaryOperation((Double, Double)->Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "^": Operation.binaryOperation({pow($0, $1)}),
        "abs": Operation.unaryOperation(abs),
        "±" : Operation.unaryOperation({-$0}),
        "×" : Operation.binaryOperation({$0 * $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "=" : Operation.equals,
        "C" : Operation.clear
        
    ]
    
    mutating func setOperation(_ symbol: String) {
        sequenceOfOperationsAndOperands.append(CalculatorButton.Operation(symbol))
    }
    
    mutating func setOperand(_ operand: Double) {
        sequenceOfOperationsAndOperands.append(CalculatorButton.number(operand))
    }
    
    mutating func setOperand(variable named: String) {
        if named == "C" {
            sequenceOfOperationsAndOperands = []
        } else {
        sequenceOfOperationsAndOperands.append(CalculatorButton.variable(named))
        }
    }
    
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String){
            
            var nested = false
            var pendingBinaryOperation: PendingBinaryOperation?
            var accumulator: Double?
            var description = ""
            var resultIsPending = false
            
            func performPendingBinaryOperation() {
                if pendingBinaryOperation != nil && accumulator != nil {
                    accumulator = pendingBinaryOperation!.perform(with: accumulator!)
                    pendingBinaryOperation = nil
                    resultIsPending = false
                }
            }
            
            func performOperation(_ symbol: String){
                
                if let operation = operations[symbol] {
                    switch operation {
                    case .constant(let value):
                        accumulator = value
                        if(!resultIsPending) {
                            description = "\(symbol)"
                        } else {
                            description = description + "\(symbol)"
                            nested = true
                        }
                        
                    case .unaryOperation(let function):
                        if accumulator != nil {
                            if (resultIsPending) {
                                description = description + "\(symbol)(\(accumulator!)) "
                                nested = true
                            } else if description == "" {
                                description = "\(symbol)(\(accumulator!))"
                            }
                            else {
                                description = "\(symbol)(\(description))"
                            }
                            accumulator = function(accumulator!)
                        }
                    case .binaryOperation(let function):
                        if accumulator != nil {
                            
                            if (description.isEmpty){
                                description = "\(accumulator!) \(symbol) "
                            } else if resultIsPending {
                                description = description + "\(accumulator!) \(symbol) "
                            } else {
                                description = description + "\(symbol) "
                            }
                            
                            if (resultIsPending) {
                                performPendingBinaryOperation()
                            }
                            
                            pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                            accumulator = nil
                            resultIsPending = true
                        }
                    case .equals:
                        if (!nested){description = description + "\(accumulator!)"}
                        nested = false
                        performPendingBinaryOperation()
                    case .clear:
                        nested = false
                        accumulator = 0.0
                        description = ""
                        resultIsPending = false
                    }
                }
            }
            
            func setAccumulator(_ operand: Double) {
                accumulator = operand
                if(!resultIsPending) {
                    description = ""
                }
            }
            
            for button in sequenceOfOperationsAndOperands {
                switch button {
                case .variable(let variable):
                    accumulator = 0.0
                    if let variables = variables {
                        accumulator = variables[variable]
                    }
                case .number(let value):
                    setAccumulator(value)
                case .Operation(let value):
                    performOperation(value)
                }
            }
            
            return (accumulator, resultIsPending, description)
    }
    
}









