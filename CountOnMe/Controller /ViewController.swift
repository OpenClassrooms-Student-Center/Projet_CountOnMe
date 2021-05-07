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
    var alerteManager = AlerteManager()
    var model = Logic(){
        didSet{
            self.textView.text = model.currentValue
        }
    }
  
    
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        //we check if we have a "=" in the calculates
        if model.expressionHaveResult {
            //if yes, we reset the controller value;
            model.resetInfo()
        }
        //we call the function model.updateInfo when we tape a number button
        model.updateInfo(numberText)
        if model.divideByZero() == true{
            alerteManager.alerteVc(.divisionZero, self)
        }
    }
    

    
    //we check if the last caracter is "+", "-", "x" or "/" when we push the button "+"
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        //if no, we add "+"
        if model.canAddOperator{
            if model.alreadyANumber{
                model.continueCalcul()
                model.updateInfo(" + ")
            } else {
                alerteManager.alerteVc(.missingNumber, self)
            }
        } else {
            //if yes, we call an alertVc
            alerteManager.alerteVc(.operatorsAlreadyPresent, self)
        }
    }
    
    //we check if the last caracter is "+", "-", "x" or "/" when we push the button "-"
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if model.canAddOperator{
            if model.alreadyANumber{
                model.continueCalcul()
                model.updateInfo(" - ")
            }else{
                alerteManager.alerteVc(.missingNumber, self)
            }
        } else {
            //if yes, we call an alertVc
            alerteManager.alerteVc(.operatorsAlreadyPresent, self)
        }
    }
    
    //we check if the last caracter is "+", "-", "x" or "/" when we push the button "x"
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if model.canAddOperator{
            if model.alreadyANumber{
                model.continueCalcul()
                model.updateInfo(" x ")
            }else{
                alerteManager.alerteVc(.missingNumber, self)
            }
        } else {
            //if yes, we call an alertVc
            alerteManager.alerteVc(.operatorsAlreadyPresent, self)
        }
    }
    
    //we check if the last caracter is "+", "-", "x" or "/" when we push the button "/"
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if model.canAddOperator{
            if model.alreadyANumber{
                model.continueCalcul()
                model.updateInfo(" / ")
                model.updateHaveADivision()
            }else{
                alerteManager.alerteVc(.missingNumber, self)
            }
        } else {
            //if yes, we call an alertVc
            alerteManager.alerteVc(.operatorsAlreadyPresent, self)
        }
    }
    
    
    @IBAction func tappedAcButton(_ sender: UIButton) {
        model.resetInfo()
    }
    
    
    @IBAction func tappedPointButton(_ sender: UIButton) {
        if model.canAddOperator {
            if model.haveAPoint() == false{
                model.updateInfo(".")
            }
        } else {
            //if yes, we call an alertVc
            alerteManager.alerteVc(.operatorsAlreadyPresent, self)
        }
    }
    
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard model.canAddOperator else {
           return alerteManager.alerteVc(.calculateIncomplete, self)
        }
        
        guard model.expressionHaveEnoughElement else {
           return  alerteManager.alerteVc(.calculateIncomplete, self)
        }
        if !model.expressionHaveResult{
            model.updateInfo(" = \(model.operationsToReduce.first!)")
        }else{
            alerteManager.alerteVc(.alreadyAnEqual, self)
        }
    }
}
