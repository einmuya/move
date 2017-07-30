//
//  HomeViewController.swift
//  Move
//
//  Created by einmuya on 7/29/17.
//  Copyright © 2017 Crafted. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    var category = [Categories]()
    var categoryId = Int()
    var createdDate = Int()
    var updatedDate = Int()
    var categoryTitle = String()
    var categoryImage = String()
    
    // MARK: Activity Indicators
    var refresh = UIRefreshControl()
    let loadingBar = LoadingBar(text: "Loading")
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle Refresh
        refresh.tintColor = UIColor.darkGray
        refresh.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresh)
        
        // Setup LoadingBar
        view.addSubview(loadingBar)
        loadingBar.hide()
        
        // tableView HeaderHeight
        tableView.sectionHeaderHeight = 80
        
        // tableView AutoHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        

        DispatchQueue.main.async(execute: {
            self.handleAPIRequest()
        })
        

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        cell.selectionStyle = .none
        let categoryFeed = category[(indexPath as NSIndexPath).row]
        
        if indexPath.row == 0{
            
            // Setup category button
            cell.categoryButton.categoryButton()
            
            // Set up category view
            let imageURL = URL(string: categoryFeed.categoryImage)
            cell.categoryImage.hnk_setImageFromURL(imageURL!)
            cell.categoryDescription.text = categoryFeed.categoryTitle
            
        }else {
            // Remove category button constraint & hide the category button view
            cell.topConstraint.constant = 0
            cell.buttonView.isHidden = true
            
            // Set up category view
            let imageURL = URL(string: categoryFeed.categoryImage)
            cell.categoryImage.hnk_setImageFromURL(imageURL!)
            cell.categoryDescription.text = categoryFeed.categoryTitle
        }
        
        return cell
    }
    
    
    func handleRefresh(_ sender: UIRefreshControl){
        if category.count > 0{
            category.removeAll()
            handleAPIRequest()
            self.tableView.reloadData()
            sender.endRefreshing()
        }else {
            sender.endRefreshing()
        }
    }
    
    func handleAPIRequest(){
        
        loadingBar.show()
        
        // API Request
        let baseURL = K.Base.URL
        let user = K.User.Name
        let password = K.User.Password
        
        // Authorization
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(baseURL, headers: headers)
            .authenticate(user: user, password: password)
            .responseJSON{
                response in
                guard response.result.error == nil else {
                    
                    // Error handling
                    print("error calling post")
                    let error = response.result.error! as NSError
                    
                    if error.code == -1004 {
                        self.alert("Could not connect to the server", message: "Try Again Later ")
                    }else if error.code == -1005{
                        self.alert("The network connection was lost", message: "Refresh your Internet Connection ")
                    }else {
                        print(response.result.error! as NSError)
                    }
                    //self.loadingBar.hide()
                    return
                }
                
                if let data = response.result.value{
                    self.loadingBar.hide()
                    // Extract Received API Data
                    for categories in data as! [Dictionary<String, AnyObject>]{
                        
                        // Extract category_id
                        if let category_id = categories["id"] as? Int {
                            self.categoryId = category_id
                        }
                        
                        // Extract created_at
                        if let created_at = categories["created_at"] as? Int {
                            self.createdDate = created_at
                        }
                        
                        // Extract updated_at
                        if let updated_at = categories["updated_at"] as? Int {
                            self.updatedDate = updated_at                        }
                        
                        // Extract title
                        if let title = categories["title"] as? String {
                            self.categoryTitle = title
                        }
                        
                        // Extract image
                        if let image = categories["image"] as? String {
                            self.categoryImage = image
                        }
                        
                        // Load extracted data into Categories Model Class
                        let categoryData = Categories(categoryId: self.categoryId, createdDate: self.createdDate, updatedDate: self.updatedDate, categoryTitle: self.categoryTitle, categoryImage: self.categoryImage)
                        
                        DispatchQueue.main.async(execute: {
                            // store data in category array
                            self.category.append(categoryData)
                            self.tableView.reloadData()
                        })
                    }
                    
                }
        }//#end-Alamofire
        
    }

    
    // Alert Message
    func alert(_ title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }

}
