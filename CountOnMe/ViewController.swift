//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SimpleCalcDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    /// View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if expressionHaveResult {
            textView.text = ""
        }
        textView.text.append(numberText)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" + ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" - ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" / ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" * ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedPercentageButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" % ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedCommaButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(",")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedReverseButton(_ sender: UIButton) {
        let nbCharToDelete: Int
        let lastFigure = textView.text.split(separator: " ").last
        guard var figure = lastFigure else { return }
        if textView.text.count > figure.count {
            nbCharToDelete = figure.count + 1
        } else {
            nbCharToDelete = figure.count
        }
        textView.text.removeLast(nbCharToDelete)
        if figure.first == "-" {
            figure.removeFirst()
        } else {
            figure.insert("-", at: figure.startIndex)
        }
        textView.text.append(contentsOf: " " + figure + " ")
    }
    
    @IBAction func tappedCEButton(_ sender: UIButton) {
        textView.text.removeAll()
    }
    
    @IBAction func tappedCButton(_ sender: UIButton) {
        if textView.text.count >= 1 {
            textView.text.removeLast(1)
        }
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionIsCorrect else {
            alertMessage(title: "Zéro!", message: "Entrez une expression correcte !")
            return
        }
        
        guard expressionHaveEnoughElement else {
            alertMessage(title: "Zéro!", message: "Démarrez un nouveau calcul !")
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        let processCalc = SimpleCalc()
        processCalc.delegate = self
        //processCalc.viewController = self
    
        let result = simpleCalcDelegate!.didDataProcessing(elements: elements)
        print("\(result)")
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "*": result = left * right
            case "/": result = left / right
            case "%": result = left % right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        textView.text.append(" = \(operationsToReduce.first!)")
    }
    
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" &&
            elements.last != "-" &&
            elements.last != "*" &&
            elements.last != "/" &&
            elements.last != "%"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" &&
            elements.last != "-" &&
            elements.last != "*" &&
            elements.last != "/" &&
            elements.last != "%"
    }
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    
    weak var simpleCalcDelegate: SimpleCalcDelegate?
 
    required init?(coder: NSCoder) {
        self.processCalc = SimpleCalc()
        super.init(coder: coder)
        
    }
    var processCalc: SimpleCalc

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.processCalc.viewController = self
    }
    
    func alertMessage(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: SimpleCalcDelegate
    func didDataProcessing(elements: [String]) -> [String] {
        print(elements)
        return elements
    }
}
