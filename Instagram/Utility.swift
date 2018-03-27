//
//  Utility.swift
//  Instagram
//
//  Created by Vishal Verma on 2018-03-24.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import Foundation

class Utility
{
    static func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
