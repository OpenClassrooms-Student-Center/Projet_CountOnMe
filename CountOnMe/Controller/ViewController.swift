//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var numberButtons: [UIButton]!
  @IBOutlet weak var textView: UITextView!

  var expression = Expression()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // View actions
  @IBAction func tappedNumberButton(_ sender: UIButton) {
    guard let numberText = sender.title(for: .normal) else {
      return
    }

    if expression.haveResult {
      expression.clear()
    }

    expression.entered.append(numberText)
    display(expression.entered)
  }

  @IBAction func tappedAdditionButton(_ sender: UIButton) {
    if expression.canAddOperator {
      expression.entered.append(" + ")
      display(expression.entered)
    } else {
      displayError()
    }
  }

  @IBAction func tappedSubstractionButton(_ sender: UIButton) {
    if expression.canAddOperator {
      expression.entered.append(" - ")
      display(expression.entered)
    } else {
      displayError()
    }
  }

  @IBAction func tappedEqualButton(_ sender: UIButton) {
    guard expression.isCorrect else {
      displayError()
      return
    }

    guard expression.haveEnoughElement else {
      displayError()
      return
    }

    // Create local copy of operations
    var operationsToReduce = expression.elements

    // Iterate over operations while an operand still here
    while operationsToReduce.count > 1 {
      let left = Int(operationsToReduce[0])!
      let operand = operationsToReduce[1]
      let right = Int(operationsToReduce[2])!

      let result: Int
      switch operand {
      case "+": result = left + right
      case "-": result = left - right
      default: fatalError("Unknown operator !")
      }

      operationsToReduce = Array(operationsToReduce.dropFirst(3))
      operationsToReduce.insert("\(result)", at: 0)
    }

    expression.entered.append(" = \(operationsToReduce.first!)")
    display(expression.entered)
  }

  private func display(_ stringToDisplay: String) {
    textView.text = stringToDisplay
  }

  private func displayError() {
    let alertVC = UIAlertController(title: "Zéro!", message: "message", preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return present(alertVC, animated: true, completion: nil)
  }
}

/*

 tappedAdditionButton

 let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
 alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
 self.present(alertVC, animated: true, completion: nil)


tappedSubstractionButton

let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
self.present(alertVC, animated: true, completion: nil)

 tappedEqualButton > expression.isCorrect

 let alertVC = UIAlertController(
   title: "Zéro!",
   message: "Entrez une expression correcte !",
   preferredStyle: .alert)
 alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
 return self.present(alertVC, animated: true, completion: nil)

 tappedEqualButton > expression.haveEnoughElement


 let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
 alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
 return self.present(alertVC, animated: true, completion: nil)


 */
