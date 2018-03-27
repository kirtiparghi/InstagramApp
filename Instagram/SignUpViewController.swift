//
//  SignUpViewController.swift
//  Instagram
//
//  Created by Vishal Verma on 2018-03-23.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController
{
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var label_RememberMe: UILabel!
    @IBOutlet weak var textfield_FirstName: UITextField!
    @IBOutlet weak var textfield_Lastname: UITextField!
    @IBOutlet weak var textfield_Emailid: UITextField!
    @IBOutlet weak var textfield_Password: UITextField!
    @IBOutlet weak var textfield_ConfirmPwd: UITextField!
    @IBOutlet weak var btn_SignUp: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "SIGNUP"
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Courier New", size: 20)!]
        
        gestureMethod()
        createGradientLayer()
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
            let alertBox = UIAlertController(title: "Instagram", message: "Registered Successfully", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                
                self.navigationController?.popViewController(animated: true)
            })
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
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
