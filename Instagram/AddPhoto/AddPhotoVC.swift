//
//  AddPhotoVC.swift
//  Instagram
//
//  Created by Kirti Parghi on 3/30/18.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class AddPhotoVC: UIViewController,CLLocationManagerDelegate, UITextViewDelegate
{

    let userDefaults = UserDefaults.standard

    var locationManager: CLLocationManager!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var btnAdd:UIButton!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var textviewDesc:UITextView!
    
    var gradientLayer: CAGradientLayer!

    var image:UIImage!
    
    var currentLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ADD PHOTO"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Courier New", size: 20)!]
        
        imgView.image = image
        createGradientLayer()
        getUserLocation()
        
        textviewDesc.text = "Enter Description"
        textviewDesc.textColor = UIColor.lightGray
        //textviewDesc.becomeFirstResponder()
        textviewDesc.selectedTextRange = textviewDesc.textRange(from: textviewDesc.beginningOfDocument, to: textviewDesc.beginningOfDocument)
        textviewDesc.returnKeyType = UIReturnKeyType.done
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description"
            textView.textColor = UIColor.lightGray
        }
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {            
            textView.text = "Enter Description"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        else if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
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
    
    @IBAction func btnAddPhotoTapped(sender:UIButton)
    {
        if(textviewDesc.text == "") {
            let alertBox = UIAlertController(title: "Instagram", message: "Please enter description", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else {
          self.addNewPhotoDB()
        }
    }

    func addNewPhotoDB() {
        view.endEditing(true)
        if(textviewDesc.text?.isEmpty == true || textviewDesc.text == nil)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Please enter photo description", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
            return
        }
        
        //GET TOTAL PHOTOS IN DB
        let request : NSFetchRequest<Photos> = Photos.fetchRequest()
        var count = 0
        do {
            let results = try myContext.fetch(request)
            count = results.count
        }
        catch {
            print("Error while fetching photos")
        }
        
        let photo = Photos(context: myContext)
        photo.photoid = String("\(count+1)")
        photo.desc = textviewDesc.text
        photo.datetime = String("\(Date())")
        photo.useremail = self.userDefaults.value(forKey: "email") as? String
        let imageData:NSData = UIImagePNGRepresentation(self.image!)! as NSData
        photo.imgdata = imageData.base64EncodedString(options: .lineLength64Characters)
        photo.latitude = String("\(self.currentLocation.coordinate.latitude)")
        photo.longitude = String("\(self.currentLocation.coordinate.longitude)")
        print(self.userDefaults.value(forKey: "firstname"))
        let user = User(context: myContext)
        user.firstname = self.userDefaults.value(forKey: "firstname") as! String
        user.lastname = self.userDefaults.value(forKey: "lastname") as! String
        user.emailid = self.userDefaults.value(forKey: "email") as! String
        user.password = self.userDefaults.value(forKey: "password") as! String
        user.latitude = self.userDefaults.value(forKey: "latitude") as! String
        user.longitude = self.userDefaults.value(forKey: "longitude") as! String
        
        photo.user = user
        do {
            try myContext.save()
            let alertBox = UIAlertController(title: "Instagram", message: "Photo Added Successfully", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                self.navigationController?.popViewController(animated: true)
            })
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
            
            print("photo data...........")
//            let request1 : NSFetchRequest<Photos> = Photos.fetchRequest()
//            do {
//                let results1 = try myContext.fetch(request1)
//                for user in results1 {
//                    print(user.desc!)
//                }
//            }
//            catch {
//                print("Error while fetching photos")
//            }
        }
        catch {
            print("an error occured while saving: \(error)")
        }
    }

    func createGradientLayer()//For view background
    {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.btnAdd.bounds
        
        let colorTop = UIColor(red: 238.0 / 255.0, green: 9.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0 / 255.0, green: 106.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        self.btnAdd.layer.addSublayer(gradientLayer)
    }
}
