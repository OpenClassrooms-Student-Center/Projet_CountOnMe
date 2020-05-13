//
//  ArithmetiqueUnit.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 06/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

class SimpleCalc {
    
    weak var delegate: SimpleCalcDelegate?
    
    func somme() -> Void{
        
        delegate?.didDataProcessing(elements: [])
    }
}
