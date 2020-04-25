//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - INTERNAL

    // MARK: Properties
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var priorityOperatorButtons: [UIButton]!

    // MARK: Methods

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

    // MARK: - PRIVATE

    // MARK: Properties

    private let cleaner = CleanerImplementation()

    lazy private var calculator = CalculatorImplementation(cleaner: cleaner)

    ///Returns true if the text of textView is empty or contains a relative sign
    /// in order to prevent starting with a wrong operator
    private var haveToDisablePriorityOperatorButtons: Bool {
        return textView.text == ""
            || textView.text == MathOperator.plus.symbol
            || textView.text == " \(MathOperator.plus.symbol) "
            || textView.text == MathOperator.minus.symbol
            || textView.text == " \(MathOperator.minus.symbol) "
    }

    // MARK: Methods

    ///Presents an alert with the given title and message
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

    // MARK: - INTERNAL

    // MARK: Methods

    ///Assigns the value of the given String to textView.text and controls the enable state of priorityOperatorButtons
    func didUpdateTextToCompute(text: String) {
        textView.text = text
        switchPriorityOperatorButtonsEnableState()
    }

    // MARK: - PRIVATE

    // MARK: Methods

    ///Switches the enable state of priorityOperatorButton according to haveToDisablePriorityOperatorButtons
    private func switchPriorityOperatorButtonsEnableState() {
        if haveToDisablePriorityOperatorButtons {
            priorityOperatorButtons.forEach { $0.isEnabled = false }
        } else if priorityOperatorButtons[0].isEnabled == false {
            priorityOperatorButtons.forEach { $0.isEnabled = true }
        }
    }
}
