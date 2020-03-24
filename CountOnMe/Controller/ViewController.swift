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

    let calculator = Calculator()

    // MARK: - App Life Running
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.isEditable = false

        for button in allButtons {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 1
            button.layer.cornerRadius = 4.0
        }

        textView.layer.cornerRadius = 6.0

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateText),
        name: Notification.Name("updateCalcul"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayError(_:)),
                                            name: Notification.Name("error"), object: nil)
    }

    // MARK: - When a button is tapped

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.addNumber(numberText)
    }

    @IBAction func tappedCommaButton(_ sender: UIButton) {
        calculator.addDecimal()
    }

    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        calculator.addOperator("+")
    }

    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        calculator.addOperator("-")
    }

    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        calculator.addOperator("x")
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        calculator.addOperator("/")
    }

    @IBAction func tappedClearButton(_ sender: UIButton) {
        calculator.reset()
    }

    // When a Button is tapped -> Display is updated
    @objc func updateText() {
        textView.text = calculator.operationStr
    }

    // When Button "=" is tapped -> Display operation's result
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.tappedEqual()
    }

    func alert(_ message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }

    @objc func displayError(_ notif: Notification) {
        if let message = notif.userInfo?["message"] as? String {
            alert(message)
        } else {
            alert("Erreur Inconnue")
        }
    }

}
