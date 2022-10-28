//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
// swiftlint:disable line_length

import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak private var textView: UITextView!
    @IBOutlet private var numberButtons: [UIButton]!
    @IBOutlet weak private var equalButton: UIButton!

    private var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    private var calculator = Calculator()

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.isScrollEnabled=true
    }

    // View actions
    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        if calculator.theExpressionHaveResult(text: textView.text) {
            textView.text = ""

            equalButton.isEnabled = true
            equalButton.layer.opacity = 1
        }

        textView.text.append(numberText)
    }

    @IBAction private func tappedAdditionButton(_ sender: UIButton) {
        if calculator.theExpressionCanAddOperator(elements: elements) && !calculator.theExpressionHaveResult(text: textView.text) { // swiftlint:disable line_length
            textView.text.append(" + ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }

    @IBAction private func tappedSubstractionButton(_ sender: UIButton) {
        if calculator.theExpressionCanAddOperator(elements: elements) && !calculator.theExpressionHaveResult(text: textView.text) { // swiftlint:disable line_length
            textView.text.append(" - ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }

    @IBAction private func tappedMultiplicationButton(_ sender: UIButton) {
        if calculator.theExpressionCanAddOperator(elements: elements) && !calculator.theExpressionHaveResult(text: textView.text) { // swiftlint:disable line_length
            textView.text.append(" × ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }

    @IBAction private func tappedDivisionButton(_ sender: UIButton) {
        if calculator.theExpressionCanAddOperator(elements: elements) && !calculator.theExpressionHaveResult(text: textView.text) {
            textView.text.append(" ÷ ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }
    }

    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        if !calculator.theExpressionIsCorrect(elements: elements) {
            alertMessage(title: "Zéro!", message: "Entrez une expression correcte !")
        } else if !calculator.theExpressionHaveEnoughElement(elements: elements) {
            alertMessage(title: "Zéro!", message: "Démarrez un nouveau calcul OK !")
        } else {

            let result = calculator.calculate(operation: elements)
            textView.text.append(" = \(result)")

            equalButton.isEnabled = false
            equalButton.layer.opacity = 0.3
        }
    }

    private func alertMessage(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
}
