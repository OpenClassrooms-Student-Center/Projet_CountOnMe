//
//  ViewController.swift
//  CountOnMe
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  // MARK: IBOutlets

  @IBOutlet var numberButtons: [UIButton]!
  @IBOutlet var operatorButtons: [UIButton]!
  @IBOutlet weak var textView: UITextView!

  // MARK: IBActions

  @IBAction func tappedAllClearButton(_ sender: UIButton) {
    expression.allClear()
    display(expression.entered)
  }

  @IBAction func tappedClearButton(_ sender: UIButton) {
    if !expression.hasResult {
      expression.clear()
    }
    display(expression.entered)
  }

  @IBAction func tappedEqualButton(_ sender: UIButton) {
    expression.calculate()
    display(expression.entered)
  }

  @IBAction func tappedNumberButton(_ sender: UIButton) {
    guard let numberText = sender.title(for: .normal) else {
      return
    }
    expression.addNumber(numberText)
    display(expression.entered)
  }

  @IBAction func tappedOperatorButton(_ sender: UIButton) {
    switch sender.tag {
    case 0:
      expression.addOperator(.addition)
    case 1:
      expression.addOperator(.substraction)
    case 2:
      expression.addOperator(.multiplication)
    case 3:
      expression.addOperator(.division)
    default:
      return
    }
    display(expression.entered)
  }

  // MARK: Private Variables

  private var expression = Expression()

  // MARK: Internal Methods

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(gettingErrorNotification),
      name: Notification.ExpressionError.operandMissing.notificationName,
      object: nil)

    display(expression.entered)
  }

  // MARK: Private Methods

  private func display(_ stringToDisplay: String) {
    textView.text = stringToDisplay
  }

  private func displayAlert(_ error: Notification.ExpressionError) {
    let alertController = UIAlertController(
      title: error.notificationName.rawValue,
      message: error.notificationMessage,
      preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: Lexical.okay, style: .cancel, handler: nil))
    return present(alertController, animated: true, completion: nil)
  }

  // MARK: @objc Methods

  @objc func gettingErrorNotification(_ notification: Notification) {
    if let notificationName = notification.userInfo?["name"] as? Notification.Name {
      switch notificationName {
      case Notification.ExpressionError.operandMissing.notificationName:
        self.displayAlert(.operandMissing)
      default:
        return
      }
    }
  }
}
