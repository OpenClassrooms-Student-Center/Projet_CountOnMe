//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

// closure
import UIKit // 56 lignes

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    let calculator = Calculator()

     
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.tapNumberButton(numberText: numberText)
        calculator.delegate = self as? TranslateCalcul
              textView.text = calculator.calculString
       
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        calculator.addition()
        calculator.delegate = self as? TranslateCalcul
              textView.text = calculator.calculString
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        calculator.substraction()
        calculator.delegate = self as? TranslateCalcul
              textView.text = calculator.calculString

    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
         calculator.equal()
        calculator.delegate = self as? TranslateCalcul
        textView.text = calculator.calculString
    }
}





