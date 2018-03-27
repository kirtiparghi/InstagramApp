//
//  mapViewController.swift
//  Instagram
//
//  Created by Rishu Khullar on 2018-03-27.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    let LocationManager = CLLocationManager()
    
    var noLocation:CLLocationCoordinate2D!
    var viewRegion = MKCoordinateRegion()
    
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLogoutButton()
        setBackButton()

        LocationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            LocationManager.delegate = self
            LocationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.startUpdatingLocation()
        }
        let coord = CLLocationCoordinate2DMake(43.7779, -79.3447)
        let coord1 = CLLocationCoordinate2DMake(43.770489, -79.332628)
        let coord2 = CLLocationCoordinate2DMake(43.7749, -79.3247)
        let coord3 = CLLocationCoordinate2DMake(43.772348, -79.329931)
        let coord4 = CLLocationCoordinate2DMake(43.771403, -79.327184   )
        let pin = MKPointAnnotation()
        
        pin.coordinate = coord
        pin.title = "friend 1"
        map.addAnnotation(pin)
        
        let pin1 = MKPointAnnotation()
        pin1.coordinate = coord1
        pin1.title = "friend 2"
        map.addAnnotation(pin1)
        
        let pin2 = MKPointAnnotation()
        pin2.coordinate = coord2
        pin2.title = "friend 3"
        map.addAnnotation(pin2)
        
        let pin3 = MKPointAnnotation()
        pin3.coordinate = coord3
        pin3.title = "friend 4"
        map.addAnnotation(pin3)
        
        let pin4 = MKPointAnnotation()
        pin4.coordinate = coord4
        pin4.title = "friend 5"
        map.addAnnotation(pin4)
        
        self.viewRegion = MKCoordinateRegionMakeWithDistance(coord1, 500, 500)
        self.map.regionThatFits(viewRegion)
        
        // Do any additional setup after loading the view.
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
    
    @objc func backTapped() {
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        let newPin = MKPointAnnotation()
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion( center: center,  span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        map.setRegion(region, animated: true)
        
        newPin.coordinate = location.coordinate
        newPin.title = "Your location"
        map.addAnnotation(newPin)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
