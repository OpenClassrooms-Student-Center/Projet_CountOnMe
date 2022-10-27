//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var equalButton: UIButton!

    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    var calculator = Calculator()
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.isScrollEnabled=true
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        if expressionHaveResult {
            textView.text = ""

            equalButton.isEnabled = true
            equalButton.layer.opacity = 1
        }

        textView.text.append(numberText)
    }

    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if calculator.theExpressionCanAddOperator(elements: elements) && !expressionHaveResult {
            textView.text.append(" + ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }

    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if calculator.theExpressionCanAddOperator(elements: elements) && !expressionHaveResult {
            textView.text.append(" - ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }

    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if calculator.theExpressionCanAddOperator(elements: elements) && !expressionHaveResult {
            textView.text.append(" × ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if calculator.theExpressionCanAddOperator(elements: elements) && !expressionHaveResult {
            textView.text.append(" ÷ ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        if !calculator.theExpressionIsCorrect(elements: elements) {
            alertMessage(title: "Zéro!", message: "Entrez une expression correcte !")
        }

        if !calculator.theExpressionHaveEnoughElement(elements: elements) {
            alertMessage(title: "Zéro!", message: "Démarrez un nouveau calcul OK !")
        }

        let result = calculator.calculate(operation: elements)
        textView.text.append(" = \(result)")

        equalButton.isEnabled = false
        equalButton.layer.opacity = 0.3
    }

    private func alertMessage(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
}
