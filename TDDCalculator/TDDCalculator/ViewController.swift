//
//  ViewController.swift
//  Calculator
//
//  Created by Qwill Duvall on 6/6/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var variableDictionary: Dictionary<String,Double>?
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var sequenceOfOperations: UILabel!
    
    @IBOutlet weak var displayM: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    private var brain = CalculatorBrain()
    
    var displayMValue: String {
        get {
            return displayM.text!
        }
        set {
            displayM.text = String(newValue)
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if !(textCurrentlyInDisplay.contains(".") && digit == ".") {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }

    func evaluateAndDisplay(){
        let (returnedResult, isPending, description) = brain.evaluate(using: variableDictionary)
        
        if let result = returnedResult {
            displayValue = result
        }
        if description == "" {
            sequenceOfOperations.text = brain.description
        }
        else if isPending {
            sequenceOfOperations.text = brain.description + "..."
        } else {
            sequenceOfOperations.text = brain.description + "="
        }
        
    }

    @IBAction func SetM(_ sender: UIButton) {
        variableDictionary = ["M" : displayValue]
        displayMValue = "M = \(displayValue)"
        evaluateAndDisplay()
        userIsInTheMiddleOfTyping = false
    }

    @IBAction func clear(_ sender: UIButton) {
        variableDictionary = nil
        displayMValue = ""
        displayValue = 0.0
    }

    @IBAction func M(_ sender: UIButton){
        brain.setOperand("M")
        evaluateAndDisplay()
        userIsInTheMiddleOfTyping = false
        //when M is 8, pi + m x displays: pi + M0.0 x\
    }
    
    @IBAction func undo(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            display.text = String(display.text!.characters.dropLast())
            if display.text!.characters.count == 0 {
                userIsInTheMiddleOfTyping = false
            }
        } else {
            brain.undo()
            evaluateAndDisplay()
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.setOperation(mathematicalSymbol)
        }
        
        evaluateAndDisplay()
    }
}
