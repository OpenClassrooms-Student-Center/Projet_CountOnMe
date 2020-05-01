// swiftlint:disable vertical_whitespace
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

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
        calculator.deleteLastElement()
    }

    @IBAction func didTapClearAllButton(_ sender: UIButton) {
        calculator.deleteAllElements()
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private var calculator = CalculatorImplementation()

    ///Returns true if the text of textView is empty or contains a relative sign
    ///in order to prevent starting with a wrong operator
    private var haveToDisablePriorityOperatorButtons: Bool {
        textView.text == ""
            || textView.text == MathOperator.plus.symbol
            || textView.text == MathOperator.minus.symbol
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

    ///Switches the enable state of priorityOperatorButton according to haveToDisablePriorityOperatorButtons
    private func switchPriorityOperatorButtonsEnableState() {
        if haveToDisablePriorityOperatorButtons {
            priorityOperatorButtons.forEach { $0.isEnabled = false }
        } else if priorityOperatorButtons[0].isEnabled == false {
            priorityOperatorButtons.forEach { $0.isEnabled = true }
        }
    }
}

extension CalculatorViewController: CalculatorDelegate {

    ///Assigns the value of the given String to textView.text and controls the enable state of priorityOperatorButtons
    func didUpdateTextToCompute(text: String) {
        textView.text = text
        switchPriorityOperatorButtonsEnableState()
    }
}
