//
//  ViewController.swift
//  calcFormatter
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    /// View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let digitTxt = sender.title(for: .normal) else {
            return
        }
        processCalc.addDigit(digitTxt: digitTxt)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        guard let operatorChar = sender.title(for: .normal) else { return }
        processCalc.addOperator(operatorChar: operatorChar)
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        guard let operatorChar = sender.title(for: .normal) else { return }
        processCalc.addOperator(operatorChar: operatorChar)
   /*     if canAddOperator {
             processCalc.addOperator(operatorChar: sender)
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }*/
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        guard let operatorChar = sender.title(for: .normal) else { return }
        processCalc.addOperator(operatorChar: operatorChar)
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        guard let operatorChar = sender.title(for: .normal) else { return }
        processCalc.addOperator(operatorChar: operatorChar)
      /*  if canAddOperator {
            textView.text.append(" * ")
        } else {
            alertMessage(title: "Zéro!", message: "Un operateur est déja mis !")
        }*/
    }
    
    @IBAction func tappedCommaButton(_ sender: UIButton) {
         processCalc.addComma()
    }
    
    @IBAction func tappedReverseButton(_ sender: UIButton) {
        processCalc.reverseFigure()
    }
    
    @IBAction func tappedCEButton(_ sender: UIButton) {
         processCalc.deleteElement(all: true)
    }
    
    @IBAction func tappedCButton(_ sender: UIButton) {
        processCalc.deleteElement(all: false)
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
         processCalc.getResult()
     }
    
    //weak var calcFormatterDelegate: CalcFormatterDelegate?
    
    private var processCalc: CalcFormatter
    
    required init?(coder: NSCoder) {
        self.processCalc = CalcFormatter()
        super.init(coder: coder)
        processCalc.delegate = self
        
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        processCalc.addDigit(digitTxt: "0")        // Do any additional setup after loading the view.
        //self.processCalc.viewController = self
    }
   
    private func alertMessage(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }

}
