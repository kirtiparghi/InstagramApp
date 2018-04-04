//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Nirav Bavishi on 2018-04-01.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
     let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var arrayPhotos: [Photos]!
    var currentPhoto : Photos!
    
    var window: UIWindow?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var feedPhotoCollectionView: UICollectionView!
    
    
    let images : [String] = ["1","2","3","4","5","6","7","8","9","10","11"]
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var photoLabel: UILabel!
    
    @IBAction func btn_Search(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "searchview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)//Segue to send data to CheckResultView view controller.
    {
        if (segue.identifier == "searchview")
        {
            let signup =  segue.destination as! SearchViewController
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        self.arrayPhotos = [Photos]()
        
        self.title = "PROFILE"
        self.navigationController?.navigationBar.tintColor = UIColor.black;
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Courier New", size: 20)!]
        
        feedPhotoCollectionView.delegate = self
        feedPhotoCollectionView.dataSource = self
        
        nameLabel.text = "\(self.userDefaults.value(forKey: "firstname") as! String) \(self.userDefaults.value(forKey: "lastname") as! String)"
        
        emailLabel.text = self.userDefaults.value(forKey: "email") as! String
        
        self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.size.width / 2;
        self.profilePhotoImageView.clipsToBounds = true;
        
        profilePhotoImageView.image = UIImage(named: "0")

        let itemSize = UIScreen.main.bounds.width / 3 - 2
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        imageCollectionView.collectionViewLayout = layout
        print(self.userDefaults.value(forKey: "email"))
        var email = self.userDefaults.value(forKey: "email")!

        let request : NSFetchRequest<Photos> = Photos.fetchRequest()
        request.predicate = NSPredicate(format: "useremail=%@", email as! CVarArg)
        do {
            self.arrayPhotos.removeAll()
            self.arrayPhotos = try myContext.fetch(request)
            
            print(self.arrayPhotos)
            
            for item in 0..<self.arrayPhotos.count {
                var i = self.arrayPhotos[item] as! Photos
                if i.useremail == nil {
                    self.arrayPhotos.remove(at: item)
                }
            }
        }
        catch {
            print("Error while saving users")
        }
        
        Misc()
    }
    
    func Misc()
    {
        //Right bar button item
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutTapped))
        logButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = logButton
        //Ends
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! feedPhotoViewCell
        
//        cell.feedPhotoCell.image = UIImage(named:images[indexPath.row])
        
        let photo = self.arrayPhotos[indexPath.row]
        
        if (photo.imgdata != nil) {
            if let decodedData = Data(base64Encoded: photo.imgdata!, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: decodedData)
                cell.feedPhotoCell.image = image
            }
//            let index = Int(arc4random_uniform(9))
            
        }
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.currentPhoto = self.arrayPhotos[indexPath.row]
//        self.performSegue(withIdentifier: "feedPhotoDetail", sender: self)

        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoDetailVC") as! PhotoDetailVC
        secondViewController.photo = self.currentPhoto
        secondViewController.isFromProfile = 1
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
}
