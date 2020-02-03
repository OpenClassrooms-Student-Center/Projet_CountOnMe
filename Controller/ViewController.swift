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
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        calculator.addition()
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        calculator.substraction()
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.equal()
    }
    
    @IBAction func tappedResetButton(_ sender: UIButton) {
        calculator.reset()
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        calculator.multiplication()
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        calculator.division()
    }
}

extension ViewController: CalculatorComunication {
   
    func updateResult(calculString: String) {
        textView.text = calculString
    }
    
    func displayAlert(message: String) {
        let alertController = UIAlertController(title: "OK", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}



