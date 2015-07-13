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
    var dates = [String]()
    var money = [String]()
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
                
                self.dates.append(subJson["date"].stringValue)
                self.money.append(subJson["chiffre_journee"].stringValue + " €")
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
        return dates.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = money[row]
        cell.detailTextLabel?.text = dates[row]
        
        return cell
        
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
    }
}