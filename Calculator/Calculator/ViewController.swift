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
        let (result, _, _) = brain.evaluate(using: variableDictionary)
        if let possibleResult = result {
            displayValue = possibleResult
        }
    }
    
    @IBAction func SetM(_ sender: UIButton) {
        variableDictionary = ["M" : displayValue]
        evaluateAndDisplay()
    }
    
    @IBAction func clear(_ sender: UIButton) {
        variableDictionary = nil
        displayValue = 0.0
        
    }
    
    @IBAction func M(_ sender: UIButton) {
        brain.setOperand(variable: "M")
        evaluateAndDisplay()
        
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

// when I press "m" I want m to be in the description

//when you set M, then start typing a new number, what should happen?

//when you set M, the number you previously typed should not be saved in the sequence

//if you click a nimber, then M, what happens?
