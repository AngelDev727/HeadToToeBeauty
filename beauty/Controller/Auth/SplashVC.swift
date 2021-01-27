//
//  SplashVC.swift
//  beauty
//
//  Created by cs on 2020/3/3.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class SplashVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.gotoVC("LoginNav")
        })
    }
}
