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
    
    var userIsInTheMiddleOfTyping = false
    
    private var brain = CalculatorBrain()
   
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

    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func SetM(_ sender: UIButton) {
        //var possibleResult: Double?
        variableDictionary = ["M" : displayValue]
        let (result, _, _) = brain.evaluate(using: variableDictionary)
        if let possibleResult = result {
            displayValue = possibleResult         }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.setOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        if brain.description == "" {
            sequenceOfOperations.text = brain.description
            displayValue = 0
        }
        else if brain.resultIsPending {
            sequenceOfOperations.text = brain.description + "..."
        } else {
            sequenceOfOperations.text = brain.description + "="
        } //maybe add another function to update display
        
    }
}

