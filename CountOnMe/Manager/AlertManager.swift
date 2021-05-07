//
//  AlertManager.swift
//  CountOnMe
//
//  Created by Brian Friess on 27/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

struct AlerteManager{
    
    //we create an enumeration for our message alerteVC
    enum AlerteType{
        case operatorsAlreadyPresent
        case calculateIncomplete
        case divisionZero
        case missingNumber
        case alreadyAnEqual
        
        var description : String{
            switch self{
            case .operatorsAlreadyPresent:
                return "Un operateur est déja mis !"
            case .divisionZero:
                return "Division par 0"
            case .calculateIncomplete:
                return "Le calcule est incomplet!"
            case .missingNumber:
                return "Commencez le calcul par un chiffre"
            case .alreadyAnEqual:
                return "Resultat déjà présent"
            }
        }
    }
    

    
    func alerteVc(_ message: AlerteType, _ controller : UIViewController){
        let alertVC = UIAlertController(title: "Zéro!", message: "\(message.description)", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.present(alertVC, animated: true, completion: nil)
    }
}
