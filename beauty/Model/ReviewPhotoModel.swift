//
//  ReviewPhotoModel.swift
//  beauty
//
//  Created by cs on 2020/3/7.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import UIKit

class ReviewPhotoModel {
    
    var imgFile : UIImage?
    var imgUrl : String?
    
    init(imgFile : UIImage) {
        self.imgFile = imgFile
    }
    
    init(imgUrl : String) {
        self.imgUrl = imgUrl
    }
}
