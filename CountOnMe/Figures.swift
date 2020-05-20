//
//  ManageFigure.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 18/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Figures {
    
    var result: Double = 0.0
    private var calculationNumber: Int

    var getCurrentSeparator: String {
           let numberFormatter = NumberFormatter()
           return numberFormatter.decimalSeparator
       }
    var hasIntegerResult: Bool {
        print("test remainder :\(result.truncatingRemainder(dividingBy: 1))")
        return result.truncatingRemainder(dividingBy: 1) == 0
    }
    init() {
        self.result = 0.0
        self.calculationNumber = 0
    }
    ///return a Double type
    func convertToDouble(stringFigure: String) -> Double {
        let figure = Double(stringFigure)
        return figure ?? 0.0
    }
    
    ///format a figure with an accuracy of x digit after the comma.
    ///and return a String
    func convertToString(figure: Double, accuracy: Int) -> String {
        String(format: "%."+String(accuracy)+"f", figure)
    }
}
extension Double {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}
