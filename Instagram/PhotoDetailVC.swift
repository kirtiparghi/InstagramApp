//
//  PhotoDetailVC.swift
//  Instagram
//
//  Created by Kirti Parghi on 3/27/18.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit

class PhotoDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var imgName: String!
    
    @IBOutlet weak var tblViewComments: UITableView!
    
    @IBOutlet weak var imgPin: UIImageView!
    
    let userDefaults = UserDefaults.standard
    
    var gradientLayer: CAGradientLayer!

    @IBOutlet weak var btnAddComment: UIButton!
    
    @IBAction func btnPinTapped(sender:UIButton) {
        self.performSegue(withIdentifier: "pinSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PHOTO DETAIL"
        setLogoutButton()
        setBackButton()
        createGradientLayer()
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        imgPin.isUserInteractionEnabled = true
        imgPin.addGestureRecognizer(singleTap)
    }

    //Action
    @objc func tapDetected() {
        self.performSegue(withIdentifier: "mapsegue", sender: self)
    }
    
    func createGradientLayer()//For view background
    {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.btnAddComment.bounds
        
        let colorTop = UIColor(red: 238.0 / 255.0, green: 9.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0 / 255.0, green: 106.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        
        self.btnAddComment.layer.addSublayer(gradientLayer)
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
    
    //TABLE VIEW DATA SOURCE AND DELEGATES METHODS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentcell", for: indexPath) as! CommentCell
        cell.imgViewUser.layer.borderWidth = 3.0
        cell.imgViewUser.layer.borderColor = UIColor.clear.cgColor
        cell.imgViewUser.layer.cornerRadius = 20.0
        cell.imgViewUser.layer.masksToBounds = true
        var imgname = String(indexPath.row)
        imgname.append(".jpg")
        cell.imgViewUser.image = UIImage(named:String(imgname))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "photodetailsegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
