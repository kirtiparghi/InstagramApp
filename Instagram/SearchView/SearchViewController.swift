//
//  SearchViewController.swift
//  Instagram
//
//  Created by Vishal Verma on 2018-04-01.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let userDefaults = UserDefaults.standard

    var desc : String!
    @IBOutlet weak var textField_Search: UITextField!
    @IBOutlet weak var btn_Search: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var filteredData : [String] = []
    var filteredPost : [String] = []
    
    var imageDesc : [String] = []
    
    var userImage : [String] = []
    var userName : [String] = []
    var userPostedImage : [String] = []
    var resultData : [Photos] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "SEARCH"
        self.navigationController?.navigationBar.tintColor = UIColor.black;
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Courier New", size: 20)!]
        
        gestureMethod()
        getData()
    }
    
    func gestureMethod()
    {
        //Getures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        mainTableView.addGestureRecognizer(tapGesture)
        //Ends
    }
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    func getData()
    {        
        let request : NSFetchRequest<Photos> = Photos.fetchRequest()
        request.predicate = NSPredicate(format: "(useremail!=%@) || (useremail!=nil)", self.userDefaults.value(forKey: "email") as! CVarArg)
        do {
            resultData = try myContext.fetch(request)
            print(self.resultData)
            
            if (self.resultData.count != 0)
            {
            
            var index = 0
            for item in self.resultData {
                if item.useremail == nil {
                    self.resultData.remove(at: index)
                }
                else {
                    imageDesc.append(String(describing: item.desc!))
                    userPostedImage.append(String(describing: item.imgdata!))
                }
                index = index + 1
            }
            mainTableView.delegate = self
            mainTableView.dataSource = self
            }
            else
            {
                let alertBox = UIAlertController(title: "Instagram", message: "No records found", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertBox.addAction(okButton)
                present(alertBox, animated: true)
            }
        }
        catch {
            print("Error while saving users")
        }
    }
    
    @IBAction func btn_Search(_ sender: Any)
    {
        view.endEditing(true)
        filteredData.removeAll()
        filteredPost.removeAll()
        if(textField_Search.text == "" || textField_Search.text == nil)
        {
            let alertBox = UIAlertController(title: "Instagram", message: "Please enter data in search field.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertBox.addAction(okButton)
            present(alertBox, animated: true)
        }
        else if(textField_Search.text == "#")
        {
            mainTableView.reloadData()
        }
        else
        {
            var word = "\(textField_Search.text!)"
            
            if(imageDesc.count != 0)
            {
                var index = 0, isgetting = 0
                for i in imageDesc
                {
                    if(i == word)
                    {
                        desc = i
                        print("\(desc!)")
                        filteredData.append(i)
                        self.filteredPost.append(userPostedImage[index])
                        index = index + 1
                    }
                }
                if self.filteredPost.count == 0 {
                    self.filteredPost.removeAll()
                    self.filteredData.removeAll()
                    self.resultData.removeAll()
                    self.mainTableView.reloadData()
                    let alertBox = UIAlertController(title: "Instagram", message: "No records found", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertBox.addAction(okButton)
                    present(alertBox, animated: true)
                }
                mainTableView.reloadData()
            }
        }
    }
    
    //TABLE VIEW DATA SOURCE AND DELEGATES METHODS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! SearchTableViewCell
        
        if(filteredData.count != 0)
        {
            cell.imageview_UserImage.layer.borderWidth = 3.0
            cell.imageview_UserImage.layer.borderColor = UIColor.clear.cgColor
            cell.imageview_UserImage.layer.cornerRadius = 20.0
            cell.imageview_UserImage.layer.masksToBounds = true
            let photo = self.filteredPost[indexPath.row]
            if (photo != nil)
            {
                if let decodedData = Data(base64Encoded: photo, options: .ignoreUnknownCharacters)
                {
                    let image = UIImage(data: decodedData)
                    cell.imageview_UserPost.image = image
                }
                let index = Int(arc4random_uniform(9))
                cell.imageview_UserImage.image = UIImage(named: String("\(index).jpg"))
               // print(filteredData[indexPath.row]!)
                cell.label_PhotoDesc.text = filteredData[indexPath.row]
            }
        }
        else
        {
            cell.imageview_UserImage.layer.borderWidth = 3.0
            cell.imageview_UserImage.layer.borderColor = UIColor.clear.cgColor
            cell.imageview_UserImage.layer.cornerRadius = 20.0
            cell.imageview_UserImage.layer.masksToBounds = true
            let photo = self.resultData[indexPath.row].imgdata
            if (photo != nil)
            {
                if let decodedData = Data(base64Encoded: photo!, options: .ignoreUnknownCharacters)
                {
                    let image = UIImage(data: decodedData)
                    cell.imageview_UserPost.image = image
                }
                let index = Int(arc4random_uniform(9))
                cell.imageview_UserImage.image = UIImage(named: String("\(index).jpg"))
                cell.label_PhotoDesc.text = resultData[indexPath.row].desc
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(filteredData.count != 0)
        {
            return filteredData.count
        }
        else
        {
            return resultData.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 400.00
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

