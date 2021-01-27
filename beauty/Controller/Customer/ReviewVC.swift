//
//  ReviewVC.swift
//  beauty
//
//  Created by cs on 2020/3/7.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import Cosmos

class ReviewVC: BaseViewController {

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ratingView.didTouchCosmos = didTouchCosmos
        ratingView.didFinishTouchingCosmos = didFinishTouchingCosmos
        
        reviewTextView.text = feedback
        ratingView.text = "\(rating)/5.0"
        ratingView.rating = rating
        setNavBar()
    }
    
    private class func formatValue(_ value: Double) -> String {
        
        rating = value
        return String(format: "%.1f", value)
    }
    
    private func didTouchCosmos(_ rating: Double) {
        
        ratingView.text = ReviewVC.formatValue(rating)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
     
        ratingView.text = ReviewVC.formatValue(rating) + "/5.0"
    }
    
    func setNavBar() {
        self.title = "Your Review"
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    
    
    @IBAction func onClickOk(_ sender: Any) {
        
        feedback = reviewTextView.text
        doDismiss()
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        feedback = ""
        rating = 0
        doDismiss()
    }
}
