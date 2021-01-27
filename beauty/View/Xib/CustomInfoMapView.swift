//
//  CustomInfoMapView.swift
//  beauty
//
//  Created by cs on 2020/4/5.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import UIKit

protocol CustomInfoMapViewDelegate: class {
    func clickView()
}

class CustomInfoMapView: UIView {
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var delegate: CustomInfoMapViewDelegate?
    
    func loadView() -> CustomInfoMapView{
    
        let customInfoMapView = Bundle.main.loadNibNamed("CustomInfoMapView", owner: self, options: nil)?[0] as! CustomInfoMapView

        return customInfoMapView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomInfoWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    @IBAction func didTapButtonClicked(_ sender: Any) {
        
        delegate?.clickView()
    }
}

