//
//  UIColor+Extension.swift
//  Pedometer
//
//  Created by 张东东 on 2017/4/18.
//  Copyright © 2017年 张东东. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{

    class func colorWithHex(hexColor: u_long) -> UIColor {
        

        let red = Float((hexColor & 0xFF0000)>>16)/255.0
        let green = Float((hexColor & 0xFF0000)>>8)/255.0
        let blue = Float((hexColor & 0xFF0000))/255.0
        
       return UIColor(colorLiteralRed: red, green: green, blue:blue, alpha: 1.0)
    }
    
    
    class func colorWithHex(hexColor: u_long, alpha:Float) -> UIColor {
        
        let red = Float((hexColor & 0xFF0000)>>16)/255.0
        let green = Float((hexColor & 0xFF0000)>>8)/255.0
        let blue = Float((hexColor & 0xFF0000))/255.0
        
        return UIColor(colorLiteralRed: red, green: green, blue:blue, alpha: alpha)
        
    }

    
}

