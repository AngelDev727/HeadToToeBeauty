//
//  MapVC.swift
//  beauty
//
//  Created by cs on 2020/3/12.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class MapVC: BaseViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    var currentLocationMarker: GMSMarker?
    
    
     var tappedMarker : GMSMarker?
     var customInfoWindow : CustomInfoMapView?
    // This is important part to load nib //
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    var locationAddress = ""
    var latitude = 0.0
    var longitude = 0.0
    var dataSource = [ProviderModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Map"
        self.tappedMarker = GMSMarker()
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
        loadCustomInfoView()
    }
    
    func loadCustomInfoView() {
        
        if customInfoWindow == nil {
            customInfoWindow = CustomInfoMapView.fromNib() as CustomInfoMapView
        }
        
        customInfoWindow?.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        getProviders()
    }
    
    func getProviders() {
        
        CustomerApiManager.findProviderByLocation(service_id: key, latitude: latitude, longitude: longitude, completion: {(isSuccess,data) in

            if isSuccess {
                    
                let dict = JSON(data as Any)
                       let providers = dict[CONSTANT.USER_DATA].arrayValue
                       for one in providers {
                           let provider = ProviderModel(dict:one)
                           self.dataSource.append(provider)
                }
                
                // setMapMarkers
                self.setMapMarkers()
               
            } else {
                if data == nil {
                   self.showToast("Failed to connect to server", duration: 2, position: .bottom)
                } else {
                   let dict = JSON(data as Any)
                   let result = dict[CONSTANT.RESULT].stringValue
                   let message = dict[CONSTANT.MESSAGE].stringValue
                   if result == "fail" {
                       self.showToast("\(message)", duration: 2, position: .bottom)
                   }
                   else {
                       self.showToast("Error", duration: 2, position: .bottom)
                   }
                }
            }
               
        })
    }
    
    func setMapMarkers() {
        
        for (index, item) in dataSource.enumerated() {
            let location = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            //print("location: \(location)")
            let marker = GMSMarker()
            marker.position = location
            marker.title = "\(index)"
            marker.map = mapView
        }
        
    }
}
extension MapVC: CustomInfoMapViewDelegate {
    func clickView() {
        print("========================Click22222=====================")
    }
}

// MARK: - CLLocationManagerDelegate
extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status == .authorizedWhenInUse else {
          return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.animate(to: mapView.camera)
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        self.getProviders()
        locationManager.stopUpdatingLocation()
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
            return
        }
        self.locationAddress = lines.joined(separator: "\n")
            //print(self.locationAddress)
        }
    }
}

extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
        
        //print("position: ", position)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        customInfoWindow?.removeFromSuperview()
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("========================Click1111=====================")
        return false
    }
        
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        ///return UIView()
        
        if (marker.position.latitude == currentLocationMarker?.position.latitude) && (marker.position.longitude == currentLocationMarker?.position.longitude) {
            return UIView()
        }
        else{
            
        let infoWindow = Bundle.main.loadNibNamed("CustomInfoMapView", owner: self.view, options: nil)!.first! as! CustomInfoMapView
            if dataSource[((marker.title?.toInt())!)].providerImage != "" {
                infoWindow.userPhotoImageView.kf.indicatorType = .activity
                infoWindow.userPhotoImageView.kf.setImage(with: URL(string: dataSource[((marker.title?.toInt())!)].providerImage), placeholder: UIImage(named: "avatar"))
                

            }
            infoWindow.userNameLabel.text = dataSource[(marker.title?.toInt())!].business_name
            infoWindow.addressLabel.text = dataSource[(marker.title?.toInt())!].providerAddress

            return infoWindow
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        let providerInformationVC = self.storyboard?.instantiateViewController(withIdentifier: "ProviderInformationVC") as! ProviderInformationVC
        providerInformationVC.providerId = dataSource[(marker.title?.toInt())!].provider_id
        self.navigationController?.pushViewController(providerInformationVC, animated: true)
       
    }
}




