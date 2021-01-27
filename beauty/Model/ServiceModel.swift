//
//  ServiceModel.swift
//  beauty
//
//  Created by cs on 2020/3/4.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation

class ServiceModel{
    
    var serviceImage = ""
    var serviceType = ""
        
    init(serviceImage: String, serviceType: String){
        self.serviceImage = serviceImage
        self.serviceType = serviceType
    }
}
