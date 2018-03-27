//
//  ViewController.swift
//  Instagram
//
//  Created by Vishal Verma on 2018-03-21.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var gradientLayer: CAGradientLayer!
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var btn_Login: UIButton!
    @IBOutlet weak var textfield_Password: UITextField!
    @IBOutlet weak var textfield_Email: UITextField!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var label_RememberMe: UILabel!
    @IBOutlet weak var btn_CheckBox: UIButton!
    @IBOutlet weak var btn_Signup: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "LOGIN"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Courier New", size: 20)!]

        gestureMethod()
        createGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        rememberMeCheck()
    }
    
    func rememberMeCheck()
    {
        if(userDefaults.string(forKey: "RememberStatus") != "Remember")
        {
            if(userDefaults.string(forKey: "Email") == nil || userDefaults.string(forKey: "Pwd") == nil)
            {
                textfield_Email.text = ""
                textfield_Password.text = ""
                btn_CheckBox.setImage(UIImage(named: "remeberme_unselect"), for: .normal)
            }
            else if(userDefaults.string(forKey: "Email") != "" || userDefaults.string(forKey: "Pwd") != "")
            {
                textfield_Email.text = userDefaults.string(forKey: "Email")
                textfield_Password.text = userDefaults.string(forKey: "Pwd")
                btn_CheckBox.setImage(UIImage(named: "rememberme_select"), for: .normal)
            }
            else
            {
                textfield_Email.text = ""
                textfield_Password.text = ""
                btn_CheckBox.setImage(UIImage(named: "remeberme_unselect"), for: .normal)
            }
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
    
    @IBAction func btn_Signup(_ sender: Any)
    {
        self.performSegue(withIdentifier: "signup", sender: self)
    }
    
    @IBAction func btn_CheckBox(_ sender: Any)//Remember me functionality
    {
        view.endEditing(true)
        if(textfield_Email.text != "" || textfield_Password.text != "")
        {
            if(btn_CheckBox.currentImage == UIImage(named: "remeberme_unselect"))
            {
                btn_CheckBox.setImage(UIImage(named: "rememberme_select"), for: .normal)
                userDefaults.setValue("Remember", forKey: "RememberStatus")
                userDefaults.setValue(textfield_Email.text, forKey: "Email")
                userDefaults.setValue(textfield_Password.text, forKey: "Pwd")
            }
            else if(btn_CheckBox.currentImage == UIImage(named: "rememberme_select"))
            {
                btn_CheckBox.setImage(UIImage(named: "remeberme_unselect"), for: .normal)
                userDefaults.setValue("notRemember", forKey: "RememberStatus")
                userDefaults.setValue("", forKey: "Email")
                userDefaults.setValue("", forKey: "Pwd")
            }
        }
        else
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Please fill the fields first.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
    }
    
    @IBAction func btn_Login(_ sender: Any)
    {
        view.endEditing(true)
        if(textfield_Email.text?.isEmpty != false || textfield_Password.text?.isEmpty != false)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "All fields are mandatory", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if(Utility.isValidEmail(testStr: textfield_Email.text!) == false)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Please enter valid Email-Id", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if((self.textfield_Password.text?.count)! <= 5)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Password must be 6 or more characters", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Login Successfully", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                
                if(self.btn_CheckBox.currentImage == UIImage(named: "rememberme_select"))
                {
                    self.userDefaults.setValue(self.textfield_Email.text, forKey: "Email")
                    self.userDefaults.setValue(self.textfield_Password.text, forKey: "Pwd")
                }
                
                self.performSegue(withIdentifier: "homeview", sender: self)
            })
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)//Segue to send data to CheckResultView view controller.
    {
//        if (segue.identifier == "signup")
//        {
//            let signup =  segue.destination as! SignUpViewController
//        }
//        else if(segue.identifier == "homeview")
//        {
//            let homeview =  segue.destination as! HomeViewController
//        }
    }
    
    func createGradientLayer()//For view background
    {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        let colorTop = UIColor(red: 238.0 / 255.0, green: 9.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0 / 255.0, green: 106.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        
        btn_Signup.backgroundColor = UIColor(white: 1, alpha: 0.25)
        
        self.view.layer.addSublayer(gradientLayer)
        self.view.addSubview(btn_Login)
        self.view.addSubview(textfield_Password)
        self.view.addSubview(textfield_Email)
        self.view.addSubview(labelHeader)
        self.view.addSubview(btn_CheckBox)
        self.view.addSubview(labelHeader)
        self.view.addSubview(label_RememberMe)
        self.view.addSubview(btn_Signup)
    }
}

