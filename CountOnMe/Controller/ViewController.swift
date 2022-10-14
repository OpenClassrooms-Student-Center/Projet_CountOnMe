//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    // MARK: - Properties

    private let calculator = Calculator()

    // MARK: - Methods

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init textView
        textView.text = calculator.allClear()
    }

    // MARK: - Actions
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        textView.text = calculator.addNumber(numberText)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        textView.text = calculator.add()
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        textView.text = calculator.substract()

    }
    
    @IBAction func tappedMultiplyButton(_ sender: UIButton) {
        textView.text = calculator.multiply()
    }
    
    @IBAction func tappedDivideButton(_ sender: UIButton) {
        textView.text = calculator.divide()
    }
    
    @IBAction func tappedAllClearButton(_ sender: UIButton) {
        textView.text = calculator.allClear()
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        textView.text = calculator.equal()
    }
}
