//
//  HomeViewController.swift
//  Instagram
//
//  Created by Vishal Verma on 2018-03-23.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    let userDefaults = UserDefaults.standard
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "HOME"
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Courier New", size: 20)!]
        
        Misc()
    }
    
    func Misc()
    {
        //Right bar button item
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addTapped))
        logButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = logButton
        //Ends
    }
    
    @objc func addTapped()
    {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: "Instagram", message: "Do you really logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            //On click of yes
            self.userDefaults.setValue("notRemember", forKey: "RememberStatus")
            self.navigationController?.popToRootViewController(animated: true)
        })
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
