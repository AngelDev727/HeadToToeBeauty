//
//  ServicesListVC.swift
//  beauty
//
//  Created by cs on 2020/3/4.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
var key : Int = 0

class ServicesListVC: BaseViewController {

    @IBOutlet weak var serviceList: UICollectionView!
    
    var dataSource = [ServiceModel]()
    var hairServiceImages = ["HAIR CUT","HAIR COLOR","STYLING & FINISHING","HAIR TEXTURE","HAIR TREATMENTS","HAIR MEN'S SERVICES"]
    var hairServiceNames = ["CUT","COLOR","STYLING &\nFINISHING","TEXTURE","TREAT\nMENTS","MEN'S \nSERVICES"]
    var spaServiceImages = ["MANICURE","PEDICURE","ARTIFICIAL NAILS","HAIR REMOVAL","LASH EXTENSIONS","MAKEUP","SKIN & BODY"]
    var spaServiceNames = ["MANICURE","PEDICURE","ARTIFICIAL\nNAILS","HAIR\nREMOVAL","LASH\nEXTENSIONS","MAKEUP","SKIN &\nBODY"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
        
        if categoryStatus == 1 {
            self.title = "HAIR THERAPY"            
            loadHairServiceList()
        } else {
            self.title = "SPA THERAPY"
            loadSpaServiceList()
        }
    }
    
    func loadHairServiceList() {
        
        for i in 0 ..< hairServiceImages.count {
            let one = ServiceModel(serviceImage: hairServiceImages[i], serviceType: hairServiceNames[i])
            dataSource.append(one)
        }
        serviceList.reloadData()
    }
    
    func loadSpaServiceList() {
        for i in 0 ..< spaServiceImages.count {
            let one = ServiceModel(serviceImage: spaServiceImages[i], serviceType: spaServiceNames[i])
            dataSource.append(one)
        }
        serviceList.reloadData()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        doDismiss()
    }
}

//MARK:--Collectionview Extension
extension ServicesListVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let position = indexPath.row
        key = categoryStatus * 10 + position
        print("service key: ", key)
        gotoNavVC("SearchproviderVC")
    }
}

//MARK: UICollectionViewDataSource
extension ServicesListVC : UICollectionViewDataSource{
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceListCell", for: indexPath) as! ServiceListCell
        cell.entity = dataSource[indexPath.row]
        return cell
    }
}

extension ServicesListVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       
        let w = collectionView.frame.size.width/2-3        
        let h = w * 0.6
        
        return CGSize(width: w,height: h)
        
    }
    
}
