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
                    let (result, isPending, description) = brain.evaluate()
                    expect(result).to(beNil())
                    expect(isPending).to(be(false))
                    expect(description).to(equal(""))
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
                context("and the variable is X"){
                    beforeEach {
                        brain.sequenceOfOperationsAndOperands = []
                        brain.setOperand("X")
                    }
                    context("and there is no dictionary") {
                        
                        it("should evaluate to 0"){
                            let (result, _, _) = brain.evaluate()
                            expect(result).to(equal(0))
                        }
                        
                        it("should have a description of X"){
                            let (_, _, description) = brain.evaluate()
                            expect(description).to(equal("X"))
                        }
                        
                    }
                    
                    context("and there is a dictionary without that variable in it") {
                        it("should evaluate to 0"){
                            let (result, _, _) = brain.evaluate(using: ["M" : 1.0])
                            expect(result).to(equal(0))
                        }
                        
                        it("should have a description of X"){
                            let (_, _, description) = brain.evaluate()
                            expect(description).to(equal("X"))
                        }
                        
                    }
                    
                    context("and there is a dictionary with that variable in it") {
                        it("should evaluate to that variable's value"){
                            let (result, _, _) = brain.evaluate(using: ["X" : 1.0])
                            expect(result).to(equal(1))
                        }
                        
                        it("should have a description of X"){
                            let (_, _, description) = brain.evaluate()
                            expect(description).to(equal("X"))
                        }
                    }
 
                }
                context("and the variable is C"){
                    beforeEach {
                        brain.sequenceOfOperationsAndOperands = []
                        brain.setOperand("C")
                    }
                    context("and there is no dictionary") {
                        it("should have a description of C"){
                            let (_, _, description) = brain.evaluate()
                            expect(description).to(equal("C"))
                        }
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
                    it("should have a description of π"){
                        let (_, _, description) = brain.evaluate()
                        expect(description).to(equal("π"))
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
                    it("should have a description of e"){
                        let (_, _, description) = brain.evaluate()
                        expect(description).to(equal("e"))
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
                it("should have a description of nothing"){
                    let (_, _, description) = brain.evaluate()
                    expect(description).to(equal(""))
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
                    it("should have a description of √(4.0)"){
                        let (_, _, description) = brain.evaluate()
                        expect(description).to(equal("√(4.0)"))
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
                    it("should have a description of cos(4.0)"){
                        let (_, _, description) = brain.evaluate()
                        expect(description).to(equal("cos(4.0)"))
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
            context("when only + is in the sequence"){
                beforeEach {
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperation("+")
                }
                it("should return nothing where result is not pending"){
                    let (result, resultIsPending, _) = brain.evaluate()
                    expect(result).to(beNil())
                    expect(resultIsPending).to(be(false))
                }
                it("should have a description of nothing"){
                    let (_, _, description) = brain.evaluate()
                    expect(description).to(equal(""))
                } //you are here
            }
            context("When 1 + is in the sequence"){
                it("should evaluate to nil and result should be pending"){
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperand(1)
                    brain.setOperation("+")
                    let (result, resultIsPending, _) = brain.evaluate()
                    expect(result).to(beNil())
                    expect(resultIsPending).to(be(true))
                }
            }
            context("When 1 + 1 is in the sequence"){
                it("should evaluate to 2 and result should not be pending"){
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperand(1)
                    brain.setOperation("+")
                    brain.setOperand(1)
                    let (result, resultIsPending, _) = brain.evaluate()
                    expect(result).to(equal(1))
                    expect(resultIsPending).to(be(true))
                }
            }
            context("When 1 + 1  = is in the sequence"){
                it("should evaluate to 2 and result should not be pending"){
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperand(1)
                    brain.setOperation("+")
                    brain.setOperand(1)
                    brain.setOperation("=")
                    let (result, resultIsPending, _) = brain.evaluate()
                    expect(result).to(equal(2))
                    expect(resultIsPending).to(be(false))
                }
            }
            
            context("When 1 + = is in the sequence"){
                it("should evaluate to nil and result should be pending"){
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperand(1)
                    brain.setOperation("+")
                    brain.setOperation("=")
                    let (result, resultIsPending, _) = brain.evaluate()
                    expect(result).to(beNil())
                    expect(resultIsPending).to(be(true))
                }
            }
            
            context("When = is in the sequence"){
                it("should evaluate to nil and result should not be pending"){
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperation("=")
                    let (result, resultIsPending, _) = brain.evaluate()
                    expect(result).to(beNil())
                    expect(resultIsPending).to(be(false))
                }
            }
            
            context("When 1 + = is in the sequence"){
                it("should evaluate to nil and result should be pending"){
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperand(1)
                    brain.setOperation("+")
                    brain.setOperation("=")
                    let (result, resultIsPending, _) = brain.evaluate()
                    expect(result).to(beNil())
                    expect(resultIsPending).to(be(true))
                }
            }
            
            context("When 1 = is in the sequence"){
                it("should evaluate to 1 and result should not pending"){
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperand(1)
                    brain.setOperation("=")
                    let (result, resultIsPending, _) = brain.evaluate()
                    expect(result).to(equal(1))
                    expect(resultIsPending).to(be(false))
                }
            }
            
            context("when 2"){
                beforeEach {
                    brain.sequenceOfOperationsAndOperands = []
                    brain.setOperand(2)
                }
                
                context("^ 4 = is in the sequence of the operations"){
                    beforeEach {
                        brain.setOperand(2)
                        brain.setOperation("^")
                        brain.setOperand(4)
                        brain.setOperation("=")
                    }
                    
                    it("should evaluate to operand to the power of the operand"){
                        let (result, resultIsPending, _) = brain.evaluate()
                        expect(result).to(equal(pow(2, 4)))
                        expect(resultIsPending).to(be(false))
                    }
                    
                }
                
                context("x 4 = is in the sequence of the operations"){
                    beforeEach {
                        brain.setOperand(2)
                        brain.setOperation("×")
                        brain.setOperand(4)
                        brain.setOperation("=")
                    }
                    
                    it("should evaluate to operand times the operand"){
                        let (result, resultIsPending, _) = brain.evaluate()
                        expect(result).to(equal(2*4))
                        expect(resultIsPending).to(be(false))
                    }
                    
                }
                
                context("÷ 4 = is in the sequence of the operations"){
                    beforeEach {
                        brain.setOperand(2)
                        brain.setOperation("÷")
                        brain.setOperand(4)
                        brain.setOperation("=")
                    }
                    
                    it("should evaluate to operand divided by the second operand"){
                        let (result, resultIsPending, _) = brain.evaluate()
                        expect(result).to(equal(2/4))
                        expect(resultIsPending).to(be(false))
                    }
                    
                }

                context("- 4 = is in the sequence of the operations"){
                    beforeEach {
                        brain.setOperand(2)
                        brain.setOperation("-")
                        brain.setOperand(4)
                        brain.setOperation("=")
                    }
                    
                    it("should evaluate to operand minus the second operand"){
                        let (result, resultIsPending, _) = brain.evaluate()
                        expect(result).to(equal(2-4))
                        expect(resultIsPending).to(be(false))
                    }
                }
            }
            
            context("when you get description from the brain"){
                beforeEach {
                    brain.sequenceOfOperationsAndOperands = []
                }
                
                it("gets the same description as is returned from the evaluate"){
                    let (_, _, description) = brain.evaluate()
                    expect(brain.description).to(equal(description))
                    
                }
            }
            
            context("when you get resultIsPending from the brain"){
                beforeEach {
                    brain.sequenceOfOperationsAndOperands = []
                }
                
                it("gets the same bool as is returned from the evaluate isPending"){
                    let (_, isPending, _) = brain.evaluate()
                    expect(brain.resultIsPending).to(equal(isPending))
                    
                }
            }
            
            context("when you get result from the brain"){
                beforeEach {
                    brain.sequenceOfOperationsAndOperands = []
                }
                
                it("gets the same result as is returned from the evaluate"){
                    //                    result, isPending, description
                    brain.setOperand(1)
                    let (result, _, _) = brain.evaluate()
                    expect(brain.result).to(equal(result))
                    
                }
            }
            
            
        }
    }
}

/// calculator brain should:

//undo
//undo should go back one in the sequence of buttons pressed

//clear
//should clear everything

