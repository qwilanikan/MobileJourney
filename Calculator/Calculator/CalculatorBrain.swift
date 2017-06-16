//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Qwill Duvall on 6/7/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    var resultIsPending = false //don't use
    
    private var accumulator: Double?  // don't need this anymore, I should get rid of it
    private var operand: String?
    private var nested = false
    
    private var sequenceOfOperationsAndOperands: Array<CalculatorButton> = []
    
    private enum CalculatorButton {
        case Operation(String)
        case variable(String)
        case number(Double)
        
    }
    
    
    var description = "" //don't use
    //However, do not use any of these vars anywhere in your code in this assignment. Use evaluate instead.
    //does that mean we should get rid of them where they were being used before?
    
    
    
    var result: Double? {       //don't use (or what do we do with these? does depricated mean that we cet rid of them?)
        get {
            return accumulator
        }
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
    
    mutating func performOperation(_ symbol: String) {
        //Should I do this in evaluate?  or should this still be perform operation??  What do??
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
            
            return (0.0, false, "a descriptin")
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
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String){
            // maintain perform operation logic
            //array ????
            
            //ignore dict for now
            
            //set operand call perform operation(set operation), then evaluate to do the math
            var accumulator = 0.0
            
            var currentProperties: (result: Double?, isPending: Bool, description: String)?
            
            for button in sequenceOfOperationsAndOperands {
                switch button {
                case .variable(let value):
                    accumulator = 0.0
                case .number(let value):
                    accumulator = value
                case .Operation(let value):
                    currentProperties = performOperation(value) //maybe pass in accumulator for this to use
                }
            }
            
            
            return (0, true, "")
    }

    
    mutating func setOperand(_ operand: Double) {
        sequenceOfOperationsAndOperands.append(CalculatorButton.number(operand))
        
//        accumulator = operand
//        if(!resultIsPending) {
//            description = ""
//        }
    }
    
    mutating func setOperand(variable named: String) {
        sequenceOfOperationsAndOperands.append(CalculatorButton.variable(named))
    }
   
}







