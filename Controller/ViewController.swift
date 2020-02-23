//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak private var textView: UITextView!
    @IBOutlet private var numberButtons: [UIButton]!
    let calculator = Calculator()
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.tapNumberButton(numberText: numberText)
    }
    
    @IBAction private func tappedAdditionButton(_ sender: UIButton) {
        calculator.addition()
    }
    
    @IBAction private func tappedSubstractionButton(_ sender: UIButton) {
        calculator.substraction()
    }
    
    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        calculator.equal()
    }
    
    @IBAction private func tappedResetButton(_ sender: UIButton) {
        calculator.reset()
    }
    
    @IBAction private func tappedMultiplicationButton(_ sender: UIButton) {
        calculator.multiplication()
    }
    
    @IBAction private func tappedDivisionButton(_ sender: UIButton) {
        calculator.division()
    }
}

extension ViewController: CalculatorComunication {
    
    func updateResult(calculString: String) {
        textView.text = calculString
    }
    
    /// Alert for all case in model 
    func displayAlert(message: String) {
        let alertController = UIAlertController(title: "OK", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}



