//
//  Const.swift
//  TMSharpMenu
//
//  Created by 天明 on 2017/3/16.
//  Copyright © 2017年 天明. All rights reserved.
//

import Foundation
import UIKit

//十六进制颜色

public func HEXCOLOR(_ hexValue: Int) -> UIColor {
    return HEXACOLOR(hexValue, alpha: 1.0)
}

public func HEXACOLOR(_ hexValue: Int, alpha: CGFloat) -> UIColor {
    let red = (CGFloat((hexValue & 0xFF0000) >> 16)) / 255
    let green = (CGFloat((hexValue & 0xFF00) >> 8)) / 255
    let blue = (CGFloat(hexValue & 0xFF)) / 255
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}
