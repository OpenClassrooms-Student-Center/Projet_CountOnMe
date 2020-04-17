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
    }

    @IBAction func didTapNumberButton(_ sender: UIButton) {
        calculator.add(number: sender.tag)
    }
    
    
    @IBAction func didTapMathOperatorButton(_ sender: UIButton) {
        let mathOperator = MathOperator.allCases[sender.tag]
        calculator.add(mathOperator: mathOperator)
    }

    @IBAction func didTapEqualButton(_ sender: UIButton) {
        guard let result = calculator.calculate() else {
            print("result in ViewController is nil !")
            return
        }
        textView.text.append(" = \(result)")
    }
    
    private var calculator = CalculatorImplementation()
    
    private func presentAlert(msg: String) {
        let alertVC = UIAlertController(
            title: "Zéro !",
            message: msg,
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
    }
}
