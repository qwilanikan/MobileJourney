//
//  CalculatorBrainSpec.swift
//  TDDCalculator
//
//  Created by Qwill Duvall on 6/22/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import Quick
import Nimble
@testable import TDDCalculator

class CalculatorBrainSpec: QuickSpec {
    override func spec() {
        
        func printEntryTypesSequence(_ sequence: Array<CalculatorButton>) {
            print("------------------")
            
            for entryType in sequence{
                switch entryType{
                case .number(let value):
                    print(String(value))
                case .variable(let value), .operation(let value):
                    print(value)
                }
            }
        }
        
        var brain = CalculatorBrain()
        
        
        describe("a Calculator Brain") {
            context("when first started") {
                it("will set a number operand") {
                    brain.setOperand(1.0)
                    
                    let item = brain.sequenceOfOperationsAndOperands.popLast()
                    
                    expect(item == CalculatorButton.number(1)).to(be(true))
                }
                
                it("will set a variable operand") {
                    brain.setOperand("X")
                    
                    let item = brain.sequenceOfOperationsAndOperands.popLast()
                    
                    //printEntryTypesSequence(brain.sequenceOfOperationsAndOperands)
                    
                    expect(item == CalculatorButton.variable("X")).to(be(true))
                }
                
                it("will set an operation") {
                    brain.setOperation("+")
                    let item = brain.sequenceOfOperationsAndOperands.popLast()
                    expect(item == CalculatorButton.operation("+")).to(be(true))
                }
                
            }
            
            context("is evaluated when nothing is in the sequence"){
                beforeEach {
                    brain.sequenceOfOperationsAndOperands = []
                }

                
                    it("should return empty values") {
                    
                    //(result: Double?, isPending: Bool, description: String)
                    let (result, isPending, description) = brain.evaluate()
                    expect(result).to(beNil())
                    expect(isPending).to(be(false))
                    expect(description).to(equal(""))
                    
                    //(accumulator, resultIsPending, description)
                }
                
            }
            
            context("when one numerical operand is in the sequence"){
                beforeEach {
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperand(1)
                }
                
                it("should evaluate"){
                    let (result, isPending, description) = brain.evaluate()
                    expect(result).to(equal(1))
                    expect(isPending).to(be(false))
                    expect(description).to(equal(""))
                }
            }
            
            context("when one variable operand is in the sequence"){
                beforeEach {
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperand("X")
                }
                context("and there is no dictionary") {
                    
                    it("should evaluate to 0"){
                        let (result, _, _) = brain.evaluate()
                        expect(result).to(equal(0))
                    }
                    
                }
                
                context("and there is a dictionary without that variable in it") {
                    it("should evaluate to 0"){
                        let (result, _, _) = brain.evaluate(using: ["M" : 1.0])
                        expect(result).to(equal(0))
                    }
                }
                
                context("and there is a dictionary with that variable in it") {
                    it("should evaluate to that variable's value"){
                        let (result, _, _) = brain.evaluate(using: ["X" : 1.0])
                        expect(result).to(equal(1))
                    }
                }
                
            }
            context("When one constant operation is in the sequence"){
                context("and it is pi"){
                    beforeEach {
                        brain.sequenceOfOperationsAndOperands = []
                        brain.setOperation("π")
                    }
                    it("should evaluate to 3.14..."){
                        let (result, _, _) = brain.evaluate()
                        expect(result).to(equal(Double.pi))
                    }
                }
                
                context("and it is e"){
                    beforeEach {
                        brain.sequenceOfOperationsAndOperands = []
                        brain.setOperation("e")
                    }
                    it("should evaluate to e"){
                        let (result, _, _) = brain.evaluate()
                        expect(result).to(equal(M_E))
                    }
                }
            }
            context("when one unary operation is in the sequence"){
                beforeEach {
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperation("√")
                }
                it("should evaluate to nothing"){
                    let (result, _, _) = brain.evaluate()
                    expect(result).to(beNil())
                }
            }
            
            context("when one operand and one unary operation is in the sequence") {
                context("and the operation is square root"){
                    beforeEach {
                        brain.sequenceOfOperationsAndOperands = []
                        brain.setOperand(4)
                        brain.setOperation("√")
                    }
                    it("should evaluate to 2"){
                        let (result, _, _) = brain.evaluate()
                        expect(result).to(equal(2))
                    }
                }
                context("and the operation is cosin"){
                    beforeEach {
                        brain.sequenceOfOperationsAndOperands = []
                        brain.setOperand(4)
                        brain.setOperation("cos")
                    }
                    it("should evaluate to cos of 4"){
                        let (result, _, _) = brain.evaluate()
                        expect(result).to(equal(cos(4)))
                    }
                }
                context("and the operation is sin"){
                    beforeEach {
                        brain.sequenceOfOperationsAndOperands = []
                        brain.setOperand(4)
                        brain.setOperation("sin")
                    }
                    it("should evaluate to be sin of 4"){
                        let (result, _, _) = brain.evaluate()
                        expect(result).to(equal(sin(4)))
                    }
                }
                context("and the operation is tan"){
                    beforeEach {
                        brain.sequenceOfOperationsAndOperands = []
                        brain.setOperand(4)
                        brain.setOperation("tan")
                    }
                    it("should evaluate to be tangent of 4"){
                        let (result, _, _) = brain.evaluate()
                        expect(result).to(equal(tan(4)))
                    }
                }
                context("and the operation is abs"){
                    beforeEach {
                        brain.sequenceOfOperationsAndOperands = []
                        brain.setOperand(-4)
                        brain.setOperation("abs")
                    }
                    it("should evaluate to be 4"){
                        let (result, _, _) = brain.evaluate()
                        expect(result).to(equal(4))
                    }
                }
                context("and the operation is ±"){
                    beforeEach {
                        brain.sequenceOfOperationsAndOperands = []
                        brain.setOperand(4)
                        brain.setOperation("±")
                    }
                    it("should evaluate to be -4"){
                        let (result, _, _) = brain.evaluate()
                        expect(result).to(equal(-4))
                    }
                }
            }
            context(""){
                
            }

        }
    }
}

/// calculator brain should:

//evaluate
//evaluate should:
// various calculator functions
//is a binary operation pending
// get variable from dictionary
// if the variable is not in the dictionary, it's value is zero


//undo
//undo should go back one in the sequence of buttons pressed

//clear
//should clear everything

//result is pending 
//result
//description
// the 3 above are depricated, but they should still return the right things

