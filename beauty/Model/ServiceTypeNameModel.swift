//
//  ServiceTypeNameModel.swift
//  beauty
//
//  Created by cs on 2020/3/20.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation

class ServiceTypeListModel {
    
    var index = ""
    var serviceTypeName = ""
    var selected = false
        
    init(index: String, serviceTypeName: String, selected: Bool){
        self.index = index
        self.serviceTypeName = serviceTypeName
        self.selected = selected
    }
}
