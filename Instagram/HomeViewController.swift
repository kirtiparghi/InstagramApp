//
//  HomeViewController.swift
//  Instagram
//
//  Created by Vishal Verma on 2018-03-23.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tblViewFeeds: UITableView!
    
    let userDefaults = UserDefaults.standard
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "HOME"
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Courier New", size: 20)!]
        
        Misc()
        addProfileButton()
    }
    
    func Misc()
    {
        //Right bar button item
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addTapped))
        logButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = logButton
        //Ends
    }
    
    func addProfileButton()
    {
        let btnProfile : UIBarButtonItem = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.plain, target: self, action: #selector(profileTapped))
        btnProfile.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = btnProfile
    }
    
    @objc func profileTapped() {
        
    }
    
    @objc func addTapped()
    {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: "Instagram", message: "Do you really logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            //On click of yes
            self.userDefaults.setValue("notRemember", forKey: "RememberStatus")
            //self.navigationController?.popToRootViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
//            let viewController: HomeViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginvc") as! HomeViewController;
//            let rootViewController = self.window!.rootViewController as! UINavigationController;
//            rootViewController.pushViewController(viewController, animated: true);

            //loginvc
            
        })
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //TABLE VIEW DATA SOURCE AND DELEGATES METHODS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedsTableViewCell
        cell.imgViewUser.layer.borderWidth = 3.0
        cell.imgViewUser.layer.borderColor = UIColor.clear.cgColor
        cell.imgViewUser.layer.cornerRadius = 20.0
        cell.imgViewUser.layer.masksToBounds = true
        let imgname = indexPath.row
        cell.imgViewPic.image = UIImage(named:String(imgname))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "photodetailsegue", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var viewcontroller = segue.destination as! PhotoDetailVC
    }
}
