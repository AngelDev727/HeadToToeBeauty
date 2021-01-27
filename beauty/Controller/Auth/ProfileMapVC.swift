//
//  ProfileMapVC.swift
//  beauty
//
//  Created by cs on 2020/3/18.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import GoogleMaps

var serviceLocation = ""

class ProfileMapVC: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    var previousVC = ""
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
    }
    
    @IBAction func onClickOk(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProfileMapVC: CLLocationManagerDelegate {
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
        locationManager.stopUpdatingLocation()
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
            return
        }
            myAddress = lines.joined(separator: "\n")
            serviceLocation = lines.joined(separator: "\n")
            myLat = address.coordinate.latitude
            myLng = address.coordinate.longitude
            print("myLat========= \(myLat)")
            print("myLng========= \(myLng)")
            print("MYADDRESS========= \(myAddress)")
            print("serviceLocation========= \(serviceLocation)")
        }
    }
}

extension ProfileMapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
        
        print("position: ", position)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        showToast("Clicked")
        
    }
}
