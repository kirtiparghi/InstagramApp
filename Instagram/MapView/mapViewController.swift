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
import CoreData

class mapViewController: UIViewController, CLLocationManagerDelegate {
    
    var isAlreadyZoom = 0
    
    var user:User!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var map: MKMapView!
    let LocationManager = CLLocationManager()
    
    var noLocation:CLLocationCoordinate2D!
    var viewRegion = MKCoordinateRegion()
    
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let request : NSFetchRequest<User> = User.fetchRequest()
        do {
            let results = try myContext.fetch(request)
            for user in results {
                print(user.latitude)
                makeAnotation(lat: Double(user.latitude!)!, long: Double(user.longitude!)!, title: user.firstname!)
            }
        }
        catch {
            print("Error while saving users")
        }
        setLogoutButton()
        setBackButton()

        LocationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            LocationManager.delegate = self
            LocationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.startUpdatingLocation()
        }
        let coord1 = CLLocationCoordinate2DMake(43.7779, -79.3447)
        
        self.viewRegion = MKCoordinateRegionMakeWithDistance(coord1, 500, 500)
        self.map.regionThatFits(viewRegion)
        
        // Do any additional setup after loading the view.
    }
    func makeAnotation(lat: Double, long : Double, title: String) {
        let coord = CLLocationCoordinate2DMake(lat, long)
        
        let pin = MKPointAnnotation()
        
        pin.coordinate = coord
        pin.title = title
        map.addAnnotation(pin)
        
        
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
        
        //set region on the map
        if (isAlreadyZoom == 0) {
            let location = locations.last! as CLLocation
            let newPin = MKPointAnnotation()
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion( center: center,  span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
            map.setRegion(region, animated: true)
            isAlreadyZoom = 1
//            newPin.coordinate = location.coordinate
//            newPin.title = "Your location"
//            map.addAnnotation(newPin)
        }
        
        
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
