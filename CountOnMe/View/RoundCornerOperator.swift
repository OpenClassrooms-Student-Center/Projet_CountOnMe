//
//  RoundCornerOperator.swift
//  CountOnMe
//
//  Created by Brian Friess on 04/05/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import UIKit

class RoundCornerOperator: UIStackView {

    @IBOutlet private var RoundButtonOperator : [UIButton]!
    
    func setUpRoundButton(){
        for i in 0...RoundButtonOperator.count-1{
            RoundButtonOperator[i].layer.cornerRadius = 20
            RoundButtonOperator[i].layer.shadowOffset = .init(width: 4, height: 4)
            RoundButtonOperator[i].layer.shadowOpacity = 0.8
        }
    }
    
    override func draw(_ rect: CGRect) {
        setUpRoundButton()
    }
    

    
}
