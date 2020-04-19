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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
        setupNotificationObservers()
    }
    
    @IBAction func didTapNumberButton(_ sender: UIButton) {
        calculator.add(number: sender.tag)
    }
    
    
    @IBAction func didTapMathOperatorButton(_ sender: UIButton) {
        let mathOperator = MathOperator.allCases[sender.tag]
        calculator.add(mathOperator: mathOperator)
    }
    
    @IBAction func didTapEqualButton(_ sender: UIButton) {
        guard let result = calculator.calculate() else { return }
        textView.text.append(" = \(result)")
    }

    @IBAction func didTapClearButton(_ sender: UIButton) {
        calculator.clearTextToCompute()
    }

    @IBAction func didTapClearAllButton(_ sender: UIButton) {
        calculator.clearAllTextToCompute()
    }
    
    private var calculator = CalculatorImplementation()

    private func setupNotificationObservers() {
        ErrorMessage.allCases.forEach { createNotificationObserver(name: $0.name) }
    }

    private func createNotificationObserver(name: String) {
        let name = Notification.Name(name)
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlert(sender:)), name: name, object: nil)
    }
    
    @objc private func presentAlert(sender: Notification) {
        let alertVC = UIAlertController(
            title: "Error",
            message: getMessageValue(sender),
            preferredStyle: .alert)

        let alertAction = UIAlertAction(
            title: "OK",
            style: .cancel)

        alertVC.addAction(alertAction)

        present(alertVC, animated: true)
    }

    private func getMessageValue(_ sender: Notification) -> String {
        switch sender.name.rawValue {
        case ErrorMessage.notCorrect.name: return ErrorMessage.notCorrect.message
        case ErrorMessage.notEnough.name: return ErrorMessage.notEnough.message
        case ErrorMessage.divideByZero.name: return ErrorMessage.divideByZero.message
        default: return "Please check the expression."
        }
    }
}

extension ViewController: CalculatorDelegate {
    func didUpdateTextToCompute(text: String) {
        textView.text = text
    }
}
