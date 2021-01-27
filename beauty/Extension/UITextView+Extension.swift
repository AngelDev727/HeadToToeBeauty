//
//  UITextView+Extension.swift
//  beauty
//
//  Created by cs on 2020/3/7.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}
