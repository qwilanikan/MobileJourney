//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Qwill Duvall on 6/7/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    var resultIsPending = false
    
    private var accumulator: Double?
    private var operand: String?
    private var nested = false
    
    var description = ""
    
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
    
    mutating func performOperation(_ symbol: String) {
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
                description = ""
                nested = false
                accumulator = nil
                resultIsPending = false
            }
            
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
            resultIsPending = false
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }

    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if(!resultIsPending) {
            description = ""
        }
    }
    
    mutating func setOperand(variable named: String) {
        operand = named
    }
    
    func evaluate(using variables: Dictionary<String, Double>? = nil )
        -> (result: Double?, isPending: Bool, description: String)
    {
        
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}

struct variableDictionary {
    private var variables: Dictionary<String, Double> = [
        "M" : nil
    ]

}




