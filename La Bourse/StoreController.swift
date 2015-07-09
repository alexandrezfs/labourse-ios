//
//  ViewController.swift
//  La Bourse
//
//  Created by Alexandre NGUYEN on 28/06/15.
//  Copyright (c) 2015 La Bourse. All rights reserved.
//

import UIKit

class StoreController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    let textCellIdentifier = "TextCell"
    var swiftBlogs = [String]()
    var selectedStore = String()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navBar.topItem!.title = self.selectedStore
        
        var storeName = self.selectedStore.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let url = NSURL(string: "http://data.librairielabourse.fr/storeSales/byLocation/" + storeName!)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            let json = JSON(data: data)
            
            for (key: String, subJson: JSON) in json {
                
                self.swiftBlogs.append(subJson["date"].stringValue + " : " + subJson["chiffre_journee"].stringValue + " €")
                
                println(subJson["chiffre_journee"])
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
        
        task.resume()
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = swiftBlogs[row]
        
        return cell
        
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(swiftBlogs[row])
        
    }
}