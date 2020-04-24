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

    @IBOutlet var priorityOperatorButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
    }
    
    @IBAction func didTapNumberButton(_ sender: UIButton) {
        calculator.add(number: sender.tag)
    }

    @IBAction func didTapMathOperatorButton(_ sender: UIButton) {
        let mathOperator = MathOperator.allCases[sender.tag]
        calculator.add(mathOperator: mathOperator)
    }

    @IBAction func didTapEqualButton(_ sender: UIButton) {
        do {
            try calculator.calculate()
        } catch {
            guard let calculatorError = error as? CalculatorError else { return }
            presentAlert(title: calculatorError.alertTitle, message: calculatorError.alertMessage)
        }
    }

    @IBAction func didTapClearButton(_ sender: UIButton) {
        cleaner.delegate?.clearString()
    }

    @IBAction func didTapClearAllButton(_ sender: UIButton) {
        cleaner.delegate?.clearAllString()
    }

    private let cleaner = CleanerImplementation()

    lazy private var calculator = CalculatorImplementation(cleaner: cleaner)

    private var haveToDisablePriorityOperatorButtons: Bool {
        return textView.text == "" || textView.text == MathOperator.plus.symbol || textView.text == " \(MathOperator.plus.symbol) " || textView.text == MathOperator.minus.symbol || textView.text == " \(MathOperator.minus.symbol) "
    }

    private func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        let alertAction = UIAlertAction(
            title: "OK",
            style: .cancel)

        alertVC.addAction(alertAction)
        present(alertVC, animated: true)
    }
}

extension ViewController: CalculatorDelegate {
    func didUpdateTextToCompute(text: String) {
        textView.text = text
        switchPriorityOperatorButtonsEnableState()
    }

    private func switchPriorityOperatorButtonsEnableState() {
        if haveToDisablePriorityOperatorButtons {
            priorityOperatorButtons.forEach { $0.isEnabled = false }
        } else if priorityOperatorButtons[0].isEnabled == false {
            priorityOperatorButtons.forEach { $0.isEnabled = true }
        }
    }
}
