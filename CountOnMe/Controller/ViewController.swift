//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var allButtons: [UIButton]!

    // MARK: - App Life Running

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.isEditable = false
        calculator.delegate = self

        setupButtons()

        textView.layer.cornerRadius = 6.0
        textView.text = calculator.operationStr
    }

    // MARK: - When a button is tapped

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.addNumber(numberText)
    }

    @IBAction func tappedCommaButton(_ sender: UIButton) {
        do {
            try calculator.addDecimal()
        } catch {
            handleCalculatorError(error: error)
        }
    }

    private func handleCalculatorError(error: Error) {
        guard let calculatorError = error as? CalculatorError else {
            return
        }

       let alert = UIAlertController(title: calculatorError.title, message: calculatorError.message,
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in self.calculator.reset()}))
        present(alert, animated: true)
    }

    @IBAction func tappedOperationButton(_ sender: UIButton) {
        do {
            guard let symbol = sender.title(for: .normal)
               else { return }
           try calculator.addOperator(symbol)
        } catch {
            handleCalculatorError(error: error)
        }
       }

    @IBAction func tappedClearButton(_ sender: UIButton) {
        calculator.reset()
    }

    // When Button "=" is tapped -> Display operation's result
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        do {
            try calculator.tappedEqual()
        } catch {
            handleCalculatorError(error: error)
        }
    }

    private let calculator = Calculator()

    private func setupButtons() {
        for button in allButtons {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 1
            button.layer.cornerRadius = 4.0
        }
    }
}

extension ViewController: CalculatorDelegate {

    func operationStringDidUpdate(_ operation: String) {
        textView.text = operation
    }
}
