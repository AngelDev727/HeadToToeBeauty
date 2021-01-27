//
//  SwitchButton+Extension.swift
//  beauty
//
//  Created by cs on 2020/3/22.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import UIKit

extension UISwitch {

    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 49

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
