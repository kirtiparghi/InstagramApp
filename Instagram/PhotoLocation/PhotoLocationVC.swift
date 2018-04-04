//
//  mapViewController.swift
//  Instagram
//
//  Created by Kirti Parghi on 2018-03-31.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PhotoLocationVC: UIViewController, CLLocationManagerDelegate
{
    var latitude:String!
    var longitude:String!
    
    @IBOutlet weak var map: MKMapView!
    let LocationManager = CLLocationManager()
    
    var noLocation:CLLocationCoordinate2D!
    var viewRegion = MKCoordinateRegion()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setLogoutButton()
        setBackButton()
        
        LocationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            LocationManager.delegate = self
            LocationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.startUpdatingLocation()
        }
//        let coord = CLLocationCoordinate2DMake((latitude! as NSString).doubleValue, (longitude! as NSString).doubleValue)
//        let pin = MKPointAnnotation()
//        pin.coordinate = coord
//        pin.title = "Photo Location"
//        map.addAnnotation(pin)
//        self.viewRegion = MKCoordinateRegionMakeWithDistance(coord, 500, 500)
//        self.map.regionThatFits(viewRegion)
    }
    
    func setBackButton()
    {
        let btnBack : UIBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backTapped))
        btnBack.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = btnBack
    }
    
    func setLogoutButton() {
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutTapped))
        logButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = logButton
    }
    
    @objc func backTapped()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func logoutTapped()
    {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: "Instagram", message: "Do you really logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            //On click of yes
            self.userDefaults.setValue("notRemember", forKey: "RememberStatus")
            //self.navigationController?.popToRootViewController(animated: true)
            
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "loginvc") as UIViewController
            self.present(initialViewControlleripad, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        print(latitude)
        print(longitude)
        
        let newPin = MKPointAnnotation()
        let center = CLLocationCoordinate2D(latitude: (latitude! as NSString).doubleValue, longitude: (longitude! as NSString).doubleValue)
        let region = MKCoordinateRegion( center: center,  span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
        
        //set region on the map
        map.setRegion(region, animated: true)
        
        newPin.coordinate = CLLocationCoordinate2DMake((latitude! as NSString).doubleValue, (longitude! as NSString).doubleValue)
        newPin.title = "Your location"
        map.addAnnotation(newPin)
    }
}
