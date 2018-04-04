//
//  HomeViewController.swift
//  Instagram
//
//  Created by Vishal Verma on 2018-03-23.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var currentPhoto : Photos!
    var arrayPhotos: [Photos]!
    
    var image:UIImage!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tblViewFeeds: UITableView!
    
    let userDefaults = UserDefaults.standard
    var window: UIWindow?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.currentPhoto = Photos(context: myContext)
        self.arrayPhotos = [Photos]()
    
        self.title = "HOME"
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Courier New", size: 20)!]
        
        Misc()
        addProfileButton()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addTapped))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.arrayPhotos.count)
        fetchPhotos()
    }
    
    func fetchPhotos() {
        self.arrayPhotos.removeAll()
        let request : NSFetchRequest<Photos> = Photos.fetchRequest()
        request.predicate = NSPredicate(format: "(useremail!=%@) || (useremail!=nil)", self.userDefaults.value(forKey: "email") as! CVarArg)
        do {
            self.arrayPhotos = try myContext.fetch(request)
            print(self.arrayPhotos)
            var index = 0
            for item in self.arrayPhotos {
//                var i = self.arrayPhotos[item] as! Photos
//                print(i.useremail)
                if item.useremail == nil {
                    self.arrayPhotos.remove(at: index)
                }
                index = index + 1
            }
            
            tblViewFeeds.reloadData()
        }
        catch {
            print("Error while saving users")
        }
    }
    
    @objc func addTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func Misc()
    {
        //Right bar button item
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutTapped))
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
    
    @objc func profileTapped()
    {
        performSegue(withIdentifier: "goToProfile", sender: self)
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
            self.dismiss(animated: true, completion: nil)
            let viewController: UINavigationController = self.storyboard!.instantiateViewController(withIdentifier: "loginvc") as! UINavigationController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
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
        let photo = self.arrayPhotos[indexPath.row]
        if (photo.imgdata != nil) {
            if let decodedData = Data(base64Encoded: photo.imgdata!, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: decodedData)
                cell.imgViewPic.image = image
            }
            let index = Int(arc4random_uniform(9))
            cell.imgViewUser.image = UIImage(named: String("\(index).jpg"))
            cell.lblUserName.text = String("\(photo.user!.firstname!) \(photo.user!.lastname!)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayPhotos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentPhoto = self.arrayPhotos[indexPath.row]
        self.performSegue(withIdentifier: "photodetailsegue", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "photosegue"
        {
            let viewcontroller = segue.destination as! AddPhotoVC
            viewcontroller.image = self.image
        }
        else if segue.identifier == "searchview"
        {
            let searchview = segue.destination as! SearchViewController
        }
        else if segue.identifier == "photodetailsegue" {
            let viewcontroller = segue.destination as! PhotoDetailVC
            viewcontroller.photo = self.currentPhoto
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated:true, completion: nil)
        self.performSegue(withIdentifier: "photosegue", sender: self)
    }
}

