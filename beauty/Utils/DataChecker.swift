//
//  DataChecker.swift
//  beauty
//
//  Created by cs on 2020/3/15.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import UIKit

class DataChecker: NSObject {

//    class func `init`(dict: [String: Any], key: String) -> String {
//
//        var str : String = ""
//
//        if let nm = dict[key] as? NSNumber {
//            str = nm.stringValue
//        } else if let int = dict[key] as? Int {
//            str = String(format: "%d", int)
//        } else if let st = dict[key] as? String {
//            str = st
//        }
//
//        return str
//    }
    class func getValidationstring(dict: [String: Any], key: String) -> String {
        var str : String = ""
        
        if let nm = dict[key] as? NSNumber {
            str = nm.stringValue
        } else if let int = dict[key] as? Int {
            str = String(format: "%d", int)
        } else if let st = dict[key] as? String {
            str = st
        }
        
        return str
    }
}
