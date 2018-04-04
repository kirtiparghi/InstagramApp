//
//  SignUpViewController.swift
//  Instagram
//
//  Created by Vishal Verma on 2018-03-23.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class SignUpViewController: UIViewController,CLLocationManagerDelegate
{
    var locationManager: CLLocationManager!

    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var label_RememberMe: UILabel!
    @IBOutlet weak var textfield_FirstName: UITextField!
    @IBOutlet weak var textfield_Lastname: UITextField!
    @IBOutlet weak var textfield_Emailid: UITextField!
    @IBOutlet weak var textfield_Password: UITextField!
    @IBOutlet weak var textfield_ConfirmPwd: UITextField!
    @IBOutlet weak var btn_SignUp: UIButton!
    
    var currentLocation: CLLocation!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "SIGNUP"
        self.navigationController?.navigationBar.tintColor = UIColor.black;
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Courier New", size: 20)!]
        
        gestureMethod()
        createGradientLayer()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        getUserLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                }
            }
        }
    }
    
    func getUserLocation() {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
    }
    
    func gestureMethod()
    {
        //Getures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        view.addGestureRecognizer(tapGesture)
        //Ends
    }
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }

    @IBAction func btn_SignUp(_ sender: Any)
    {
        view.endEditing(true)
        if(textfield_FirstName.text?.isEmpty != false || textfield_Lastname.text?.isEmpty != false || textfield_Emailid.text?.isEmpty != false || textfield_Password.text?.isEmpty != false || textfield_ConfirmPwd.text?.isEmpty != false)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "All fields are mandatory", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if(Utility.isValidEmail(testStr: textfield_Emailid.text!) == false)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Please enter valid Email-Id", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if((textfield_Password.text?.count)! <= 5)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Password must be 6 or more characters", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if(textfield_Password.text != textfield_ConfirmPwd.text)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Password and Confirm Password doesn't match", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else
        {
            createNewUser()
        }
    }
    
    //core data entry for new user
    func createNewUser() {
        let user = User(context: myContext)
        user.firstname = textfield_FirstName.text
        user.lastname = textfield_Lastname.text
        user.emailid = textfield_Emailid.text
        user.password = textfield_Password.text
        
        //subway
        //43.777767, -79.336771
        //43.772534, -79.343370
        user.latitude = "43.772534"
        user.longitude = "-79.343370"
        
        //don mills
        //43.778128, -79.345354
//        user.latitude = "43.778128"
//        user.longitude = "-79.345354"
        
        //43.784036, -79.293459 tim
//        user.latitude = "43.784036"
//        user.longitude = "-79.293459"
//
        // pizza pizza
//        user.latitude = "43.777330"
//        user.longitude = "-79.322792"
        
//        user.latitude = String(self.currentLocation.coordinate.latitude)
//        user.longitude = String(self.currentLocation.coordinate.longitude)
        
        do {
            try myContext.save()
            
            let request : NSFetchRequest<Photos> = Photos.fetchRequest()
            do {
                var result = try myContext.fetch(request)
                print(result.count)
            }
            catch {
                print("Error while saving users")
            }
            
            let alertBox = UIAlertController(title: "Instagram", message: "Registered Successfully", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                    self.navigationController?.popViewController(animated: true)
            })
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        catch {
            print("an error occured while saving: \(error)")
        }
    }
    
    func createGradientLayer()
    {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        let colorTop = UIColor(red: 238.0 / 255.0, green: 9.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0 / 255.0, green: 106.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
                
        self.view.layer.addSublayer(gradientLayer)
        self.view.addSubview(textfield_FirstName)
        self.view.addSubview(textfield_Lastname)
        self.view.addSubview(textfield_Emailid)
        self.view.addSubview(textfield_Password)
        self.view.addSubview(textfield_ConfirmPwd)
        self.view.addSubview(btn_SignUp)
        self.view.addSubview(label_RememberMe)
    }
}
